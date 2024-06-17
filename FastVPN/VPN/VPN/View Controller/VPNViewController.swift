//
//  VPNViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit
import OutlineTunnel
import OutlineSentryLogger
import OutlineNotification
import CocoaLumberjack
import CocoaLumberjackSwift
import NetworkExtension
import Sentry
import SwiftMessages
import Haptica

final class VPNViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    //MARK: - Root View
    typealias RootView = VPNView
    
    //MARK: - Services
    internal let customSpinnerView = CustomSpinnerView()
    private let viewModel = VPNViewModel()
    internal var coordinator: VPNCoordinator?
    
    //MARK: - Attrbiutes
    private var shouldAnimate = false
    private let vpn = OutlineVpn.shared
    private var serverModel: ServerModel? {
        didSet {
            guard let serverModel = serverModel else { return }
            UserDefaults.standard.setVpnServer(server: serverModel.server ?? "")
            UserDefaults.standard.setHasServer(hasServer: true)
            view().serverLabel.text = serverModel.server
        }
    }
    
    //MARK: - Actions
    @IBAction func connectAction(_ sender: UIButton) {
        sender.showAnimation()
        Haptic.impact(.soft).generate()
        connectVpn()
    }
    
    @IBAction func supportAction(_ sender: UIButton) {
        sender.showAnimation()
        Haptic.impact(.soft).generate()
        openURL(urlString: MainConstants.tgSupport.rawValue)
    }
    
    @IBAction func settingsAction(_ sender: UIButton) {
        sender.showAnimation()
        Haptic.impact(.soft).generate()
        
        guard UserDefaults.standard.isHasServer() else {
            openURL(urlString: MainConstants.tgSettings.rawValue + (UIDevice.current.identifierForVendor?.uuidString ?? ""))
            return }
        viewModel.getServerInfo()
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        sender.showAnimation()
        Haptic.impact(.soft).generate()
        showAlertDestructive(message: "deleteCurrentUrl".localized, buttonTitle: "delete".localized) { [weak self] in
            guard let `self` = self else { return }
            UserDefaults.standard.removeVpnKey()
            UserDefaults.standard.removeVpnServer()
            serverModel = nil
            view().dateStackView.isHidden = true
            vpn.stop("0")
            setupButtonStatus()
        }
    }
    
    //MARK: - Lifecycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
        setupButtonStatus()
        viewModel.getServerInfo()
    }

}

//MARK: - Networking
extension VPNViewController: VPNViewModelProtocol {
    func didFinishFetch(configJson: ShadowSocksData) {
        connect(configJson: configJson.returnJSON())
        UserDefaults.standard.setVpnServer(server: configJson.host ?? "")
    }
    
    func didFinishFetch(server: ServerModel?, endDate: String?, serverName: String?, message: String?) {
        
        if let server = server {
            self.serverModel = server
        }
        
        if let _ = message {
            UserDefaults.standard.setHasServer(hasServer: false)
        }
        
        if let endDate = endDate {
            view().dateStackView.isHidden = false
            let isoDateFormatter = DateFormatter()
            isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            isoDateFormatter.locale = Locale(identifier: "en_US_POSIX")
            isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            if let date = isoDateFormatter.date(from: endDate) {
                let newDateFormatter = DateFormatter()
                newDateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
                newDateFormatter.locale = Locale.current
                newDateFormatter.timeZone = TimeZone.current
                let newDateString = newDateFormatter.string(from: date)
                view().dateLabel.text = newDateString
            } else {
                print("Невозможно преобразовать строку даты")
            }
        } else {
            view().dateStackView.isHidden = true
        }
    }
}

//MARK: - Other func
extension VPNViewController {
    private func appearanceSettings() {
        viewModel.delegate = self
        navigationItem.title = "fastVPN".localized
        navigationController?.navigationBar.installBlurEffect()
        view().addButton.addTarget(self, action: #selector(presentAddView), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view().addButton)
        
        view().animate(animation: .connected, viewController: self)
    }
    
    private func connect(configJson: [String: Any]) {
        guard !vpn.isActive("0") else {
            vpn.stop("0")
            setupButtonStatus()
            return }
        startAnimation()
        vpn.start("0", configJson: configJson) { [weak self] errorCode in
            guard let `self` = self else { return }
            if errorCode == .noError {
                Haptic.impact(.soft).generate()
                setupButtonStatus()
            } else {
                stopAnimation()
                showErrorAlert()
            }
        }
    }
    
    @objc private func presentAddView() {
        coordinator?.presentAddView(viewController: self)
    }
    
    @objc func connectVpn() {
        guard let serverModel = serverModel else { 
            guard let key = UserDefaults.standard.getVpnKey() else {
                showErrorAlert(message: "enterKey".localized)
                return
            }
            parseSSURl(url: key)
            return }
        connect(configJson: serverModel.returnJSON())
    }
    
    private func parseSSURl(url: String) {
        let fetchUrl = url.replacingOccurrences(of: "ssconf://", with: "https://")
        viewModel.connect(url: fetchUrl)
    }
    
    private func setupButtonStatus() {
        let active = vpn.isActive("0")
        self.shouldAnimate = active
        UIView.transition(with: view(), duration: 0.5, options: .transitionCrossDissolve) {
            self.view().ballBtn.isHidden = active
            self.view().animationView.isHidden = !active
        }
        view().statusLabel.text = active ? "connected".localized : "disconnected".localized
        view().statusLabel.textColor = active ? .green : .red
        view().serverLabel.text = UserDefaults.standard.getVpnServer()
        stopAnimation()
    }
    
    private func startAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
        rotationAnimation.duration = 1.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.greatestFiniteMagnitude
        view().ballBtn.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    private func stopAnimation() {
        view().ballBtn.layer.removeAnimation(forKey: "rotationAnimation")
    }
}

//MARK: - AddKeyPopUpViewControllerDelegate
extension VPNViewController: AddKeyViewControllerDelegate {
    func didFinishKey() {
        guard let key = UserDefaults.standard.getVpnKey() else { return }
        guard key.contains("ssconf://") else { 
            showErrorAlert(message: "enterValidKey".localized)
            return }
        connectVpn()
    }
}

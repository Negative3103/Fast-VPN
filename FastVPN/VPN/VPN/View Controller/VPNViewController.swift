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
    private let viewModel = VPNViewModel()
    internal var coordinator: VPNCoordinator?
    
    //MARK: - Attrbiutes
    private var shouldAnimate = false
    private let vpn = OutlineVpn.shared
    
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
        openURL(urlString: MainConstants.tgSettings.rawValue + (UIDevice.current.identifierForVendor?.uuidString ?? ""))
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        sender.showAnimation()
        Haptic.impact(.soft).generate()
        showAlertDestructive(message: "Удалить текущую ссылку?", buttonTitle: "Удалить") { [weak self] in
            guard let `self` = self else { return }
            UserDefaults.standard.removeVpnKey()
            UserDefaults.standard.removeVpnServer()
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
    }
}

//MARK: - Networking
extension VPNViewController: VPNViewModelProtocol {
    func didFinishFetch(configJson: ShadowSocksData) {
        vpn.start("0", configJson: configJson.returnJSON()) { [weak self] errorCode in
            guard let `self` = self else { return }
            if errorCode == .noError {
                UserDefaults.standard.setVpnServer(server: configJson.host ?? "")
                Haptic.impact(.soft).generate()
                setupButtonStatus()
            } else {
                stopAnimation()
                showErrorAlert()
            }
        }
    }
}

//MARK: - Other func
extension VPNViewController {
    private func appearanceSettings() {
        viewModel.delegate = self
        navigationItem.title = "Быстрый VPN"
        navigationController?.navigationBar.installBlurEffect()
        view().addButton.addTarget(self, action: #selector(presentAddView), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view().addButton)
        
        view().animate(animation: .connected, viewController: self)
    }
    
    @objc private func presentAddView() {
        coordinator?.presentAddView(viewController: self)
    }
    
    @objc func connectVpn() {
        guard let key = UserDefaults.standard.getVpnKey() else {
            showErrorAlert(message: "Для подключения добавьте ключ")
            return
        }
        parseSSURl(url: key)
    }
    
    private func parseSSURl(url: String) {
        guard !vpn.isActive("0") else {
            vpn.stop("0")
            setupButtonStatus()
            return }
        startAnimation()
        let fetchUrl = url.replacingOccurrences(of: "ssconf://", with: "https://")
        viewModel.connect(url: fetchUrl)
    }
    
    private func setupButtonStatus() {
        let active = vpn.isActive("0")
        self.shouldAnimate = active
        UIView.transition(with: view(), duration: 1.3, options: .transitionCrossDissolve) {
            self.view().ballBtn.isHidden = active
            self.view().animationView.isHidden = !active
        }
        view().statusLabel.text = active ? "Подключен" : "Отключен"
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
            showErrorAlert(message: "Введите действительную ссылку")
            return }
        connectVpn()
    }
}

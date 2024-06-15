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
        openURL(urlString: MainConstants.tgSettings.rawValue)
    }
    
    //MARK: - Lifecycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
    }
}

//MARK: - Networking

//MARK: - Other func
extension VPNViewController {
    private func appearanceSettings() {
        navigationItem.title = "Быстрый VPN"
        navigationController?.navigationBar.installBlurEffect()
        view().addButton.addTarget(self, action: #selector(presentAddView), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view().addButton)
    }
    
    @objc private func presentAddView() {
        coordinator?.presentAddView(viewController: self)
    }
        
    private func connectVpn() {
        guard let key = UserDefaults.standard.getVpnKey() else {
            showErrorAlert(message: "Для подключения добавьте ключ")
            return
        }
        parseSSURl(url: key)
    }
    
    private func parseSSURl(url: String) {
        guard let configJson = viewModel.parseShadowsocksURL(url)?.returnJSON() else {
            showErrorAlert(message: "URL error")
            vpn.stop("0")
            setupButtonStatus()
            return }
        
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
    
    private func setupButtonStatus() {
        let active = vpn.isActive("0")
        self.shouldAnimate = active
        UIView.transition(with: view(), duration: 1.3, options: .transitionCrossDissolve) {
            self.view().ballBtn.setImage(active ? .appImage(.ballActiv) : .appImage(.ballNoActiv), for: .normal)
        }
        buttonAnimation()
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
    
    private func buttonAnimation() {
        guard shouldAnimate else {
            view().viewFirst.alpha = 0
            view().viewSecond.alpha = 0
            return }
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            self.view().viewFirst.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
                self.view().viewSecond.alpha = 1
            }, completion: { _ in
                UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
                    self.view().viewFirst.alpha = 0
                }, completion: { _ in
                    UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
                        self.view().viewSecond.alpha = 0
                    }, completion: { _ in
                        self.buttonAnimation()
                    })
                })
            })
        })
    }
}

//MARK: - AddKeyPopUpViewControllerDelegate
extension VPNViewController: AddKeyViewControllerDelegate {
    func didFinishKey() {
        connectVpn()
    }
}

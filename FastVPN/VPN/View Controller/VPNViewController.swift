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
    private let ssURL = "ss://YWVzLTI1Ni1nY206ODg4OTk5@91.215.152.217:8388#%D1%82%D0%B5%D1%81%D1%82"
    
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
//        view().addButton.addTarget(self, action: #selector(), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view().addButton)
    }
        
    private func connectVpn() {
        guard let key = UserDefaults.standard.getVpnKey() else {
            showErrorAlert(message: "Для подключения добавьте ключ ШАР")
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
//        startAnimation()
        vpn.start("0", configJson: configJson) { [weak self] errorCode in
            guard let `self` = self else { return }
            if errorCode == .noError {
                Haptic.impact(.soft).generate()
                setupButtonStatus()
            } else {
//                stopAnimation()
                showErrorAlert()
            }
        }
    }
    
    private func setupButtonStatus() {
        let active = vpn.isActive("0")
        self.shouldAnimate = active
        UIView.transition(with: view(), duration: 1.3, options: .transitionCrossDissolve) {
//            self.view().ballBtn.setImage(active ? .appImage(.ballActiv) : .appImage(.ballNoActiv), for: .normal)
        }
//        buttonAnimation()
//        stopAnimation()
    }
}

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
import SignalRClient

final class VPNViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    //MARK: - Root View
    typealias RootView = VPNView
    
    //MARK: - Services
    internal let customSpinnerView = CustomSpinnerView()
    private let viewModel = VPNViewModel()
    internal var coordinator: VPNCoordinator?
    
    //MARK: - Attrbiutes
    private let monitor = NetworkMonitor.shared
    private var signalRManager = SignalRManager.signalRManager
    private var shouldAnimate = false
    private let vpn = OutlineVpn.shared
    private var serverModel: ServerModel? {
        didSet {
            guard let serverModel = serverModel else { return }
            UserDefaults.standard.setVpnServer(server: serverModel.server ?? "")
            UserDefaults.standard.setHasServer(hasServer: true)
            if let firstPart = serverModel.server?.split(separator: ".").first {
                view().serverLabel.text = String(firstPart)
            }
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
    
    //MARK: - Lifecycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
        checkUpdate()
        showUpdateVC()
        setMonitoring()
//        signalRManager.connect()
        
        guard UserDefaults.standard.isFromRestrictedCountry() else { return }
        viewModel.getServerInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkStatus()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        checkStatus()
    }

}

//MARK: - Networking
extension VPNViewController: VPNViewModelProtocol {
    func didFinishFetch(configJson: ShadowSocksData) {
        connect(configJson: configJson.returnJSON())
        UserDefaults.standard.setVpnServer(server: configJson.host ?? "")
    }
    
    func didFinishFetchRegistration(server: ServerModel?, endDate: String?, serverName: String?, message: String?) {
        if let server = server {
            self.serverModel = server
        }
        
        if let message = message {
            UserDefaults.standard.setHasServer(hasServer: false)
            showErrorAlert(message: message)
        }
        
        guard let server = server else { return }
        connect(configJson: server.returnJSON())
    }
    
    func didFinishFetch(server: ServerModel?, endDate: String?, serverName: String?, message: String?) {
        if let server = server {
            self.serverModel = server
        }
        
        if let _ = message {
            UserDefaults.standard.setHasServer(hasServer: false)
        }
    }
}

//MARK: - Other func
extension VPNViewController {
    private func appearanceSettings() {
        viewModel.delegate = self
        navigationItem.title = "fastVPN".localized
        navigationController?.navigationBar.installBlurEffect()
        view().ballBtn.setImage(.appImage(.ballActiv), for: .normal)
        
        Notification.Name.noInternet.onPost { [weak self] _ in self?.vpn.stop("0")}
        Notification.Name.deleteUrl.onPost { [weak self] _ in
            UserDefaults.standard.removeVpnKey()
            UserDefaults.standard.removeVpnServer()
            self?.serverModel = nil
            self?.vpn.stop("0")
            self?.setupButtonStatus()
        }
        
        Notification.Name.universalLink.onPost { [weak self] clientID in
            guard let clientID = clientID.object as? String else { return }
            self?.viewModel.registration(clientId: clientID)
        }
        
        Notification.Name.connectKey.onPost { [weak self] _ in
            self?.connectVpn()
        }
    }
    
    internal func setMonitoring() {
        monitor.startMonitoring()
        monitor.onConnectionTypeChanged = { connectionType in
            DispatchQueue.main.async {
                switch connectionType {
                case .wifi, .cellular, .ethernet:
                    guard let serverModel = self.serverModel else { return }
                    self.vpn.start("0", configJson: serverModel.returnJSON()) { [weak self] errorCode in
                        guard let `self` = self else { return }
                        if errorCode == .noError {
                            Haptic.impact(.soft).generate()
                            setupButtonStatus()
                        }
                        Notification.Name.getData.post()
                    }
                case .unknown:
                    self.vpn.stop("0")
                }
            }
        }
    }
    
    private func connect(configJson: [String: Any]) {
        guard !vpn.isActive("0") else {
            vpn.stop("0")
            setupButtonStatus()
            return }
        vpn.start("0", configJson: configJson) { [weak self] errorCode in
            guard let `self` = self else { return }
            if errorCode == .noError {
                Haptic.impact(.soft).generate()
                setupButtonStatus()
            }
            Notification.Name.getData.post()
        }
    }
    
    @objc func connectVpn() {
        guard UserDefaults.standard.isFromRestrictedCountry() else {
            parseSSURl(url: "ssconf://bystrivpn.ru/outline/config/5a223f65-8b14-4e0b-b485-2a367d2d9da9")
            return }
        
        viewModel.getServerInfo()
        guard let serverModel = serverModel else {
            guard let key = UserDefaults.standard.getVpnKey() else {
                vpn.stop("0")
                checkStatus()
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
            self.view().ballBtn.setImage(active ? .appImage(.ballActiv) : .appImage(.ballNoActiv), for: .normal)
        }
        if let firstPart = UserDefaults.standard.getVpnServer()?.split(separator: ".").first {
            view().serverLabel.text = String(firstPart)
        }
    }
    
    internal func checkStatus() {
        let active = vpn.isActive("0")
        self.shouldAnimate = active
        view().ballBtn.setImage(active ? .appImage(.ballActiv) : .appImage(.ballNoActiv), for: .normal)
        if let firstPart = UserDefaults.standard.getVpnServer()?.split(separator: ".").first {
            view().serverLabel.text = String(firstPart)
        }
    }
    
    private func showUpdateVC() {
        guard !UserDefaults.standard.updateIsShowed() else { return }
        coordinator?.presentUpdateVC(viewController: self)
    }
}

// MARK: - CheckToNewVersion
extension VPNViewController {
    func checkUpdate() {
        DispatchQueue.global().async {
            do {
                let update = try self.isUpdateAvailable()
                DispatchQueue.main.async {
                    if update {
                        self.popupUpdateDialogue()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func isUpdateAvailable() throws -> Bool {
        guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String,
              let url = URL(string: MainConstants.itunesPath.rawValue) else {
            throw VersionError.invalidBundleInfo
        }
        
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let newVersion = result["version"] as? String {
            return !(currentVersion >= newVersion)
        }
        throw VersionError.invalidResponse
    }
    
    func popupUpdateDialogue() {
        let alert = UIAlertController(title: "updateAvailable".localized, message: "updateMessage".localized, preferredStyle: UIAlertController.Style.alert)
        
        let updateAction = UIAlertAction(title: "update".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if let url = URL(string: MainConstants.appstorePath.rawValue),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        let nextTimeAction = UIAlertAction(title: "nextTime".localized, style: .default)
        
        alert.addAction(updateAction)
        alert.addAction(nextTimeAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//
//  PaymentViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 13/08/24.
//

import UIKit

final class PaymentViewController: UIViewController, AlertViewController, ViewSpecificController {
    
    //MARK: - Root View
    typealias RootView = PaymentView
    
    //MARK: - Services
    internal var coordinator: OnboardingCoordinator?

    //MARK: - Attributes
    
    //MARK: - Actions
    @IBAction func appleButtonAction(_ sender: UIButton) {
        // soon we will add this func
    }
    
    @IBAction func tgButtonAction(_ sender: UIButton) {
        openURL(urlString: MainConstants.tgSettings.rawValue + (UIDevice.current.identifierForVendor?.uuidString ?? ""))
    }
    
    @IBAction func nextAction(_ sedner: UIButton) {
//        KeychainAccessCheck.saveFirstLaunch()
        presentTabBarVC()
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
    }
}

//MARK: - Other funcs
extension PaymentViewController {
    private func appearanceSettings() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "choosePayment".localized
        navigationController?.navigationBar.installBlurEffect()
    }
    
    private func presentTabBarVC() {
        let tabBarVC = TabBarController()
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.modalTransitionStyle = .crossDissolve
        self.present(tabBarVC, animated: true)
    }
}

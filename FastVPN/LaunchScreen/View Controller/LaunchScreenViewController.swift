//
//  LaunchScreenViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 15/06/24.
//

import UIKit
import Lottie
import Haptica

enum LottieAnimation: String {
    case lightning
    case connected
}

final class LaunchScreenViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    //MARK: - Root View
    typealias RootView = LaunchScreenView
    
    //MARK: - Services
    private let viewModel = VPNViewModel()
    
    //MARK: - Attributes
    
    //MARK: - Lifecycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUserLocation()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
        view().animate { _ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                Haptic.impact(.soft).generate()
                self.presentTabBarVC()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

//MARK: - Other funcs
extension LaunchScreenViewController {
    private func appearanceSettings() {
        navigationController?.navigationBar.installBlurEffect()
    }
    
    private func presentTabBarVC() {
        let tabBarVC = TabBarController()
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.modalTransitionStyle = .crossDissolve
        self.present(tabBarVC, animated: true)
    }
}

//MARK: - Check Ip-Address
extension LaunchScreenViewController {
    private func saveUserLocationStatus(isFromRestrictedCountry: Bool) {
        UserDefaults.standard.isFromRestrictedCountry(isFromRestrictedCountry: isFromRestrictedCountry)
    }
    
    private func checkUserLocation() {
        viewModel.fetchIPAddress { ip in
            guard let ip = ip else {
                self.saveUserLocationStatus(isFromRestrictedCountry: false)
                return
            }
            
            self.viewModel.fetchLocation(ip: ip) { country in
                let restrictedCountries = ["RU", "IR"]
                guard let country = country else { return }
                let isFromRestrictedCountry = restrictedCountries.contains(country)
                self.saveUserLocationStatus(isFromRestrictedCountry: isFromRestrictedCountry)
            }
        }
    }
}

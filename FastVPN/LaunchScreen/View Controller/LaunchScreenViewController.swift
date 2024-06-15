//
//  LaunchScreenViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 15/06/24.
//

import UIKit
import Lottie

enum LottieAnimation: String {
    case lightning
}

final class LaunchScreenViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    //MARK: - Root View
    typealias RootView = LaunchScreenView
    
    //MARK: - Services
    
    //MARK: - Attributes
    
    //MARK: - Lifecycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
        view().animate { _ in
            self.presentTabBarVC()
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

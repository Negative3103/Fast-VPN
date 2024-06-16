//
//  AboutCoordinator.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit
import SwiftMessages

final class AboutCoordinator: Coordinator {
    
    internal var childCoordinators = [Coordinator]()
    internal var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    internal func start() {
        let vc = AboutViewController()
        vc.tabBarItem =  UITabBarItem(title: "about".localized, image: .appImage(.about), tag: 1)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    internal func pushLanguageVC(viewController: UIViewController) {
        let vc = LanguageViewController()
        if let viewController = viewController as? AboutViewController {
            vc.delegate = viewController
        }
        vc.coordinator = self
        vc.title = "chooseLanguage".localized
        navigationController.pushViewController(vc, animated: true)
    }
    
}

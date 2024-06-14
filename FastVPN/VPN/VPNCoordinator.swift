//
//  VPNCoordinator.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit
import SwiftMessages

final class VPNCoordinator: Coordinator {
    internal var childCoordinators: [Coordinator] = []
    internal var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    internal func start() {
        let vc = VPNViewController()
        vc.tabBarItem =  UITabBarItem(title: "VPN", image: .appImage(.vpn), tag: 0)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
}

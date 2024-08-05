//
//  VPNCoordinator.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit
import SwiftMessages

final class VPNCoordinator: Coordinator {
    
    internal var childCoordinators = [Coordinator]()
    internal var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    internal func start() {
        let vc = VPNViewController()
        vc.tabBarItem =  UITabBarItem(title: "vpn".localized, image: .appImage(.vpn), tag: 0)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    internal func presentAddView(viewController: UIViewController) {
        let vc = AddKeyViewController()
        vc.coordinator = self
        
        if let viewController = viewController as? VPNViewController {
            vc.delegate = viewController
        }
        
        let segue = SwiftMessagesSegue(identifier: nil, source: viewController, destination: vc)
        segue.interactiveHide = true
        segue.dimMode = .blur(style: .dark, alpha: 0.5, interactive: false)
        segue.configure(layout: .centered)
        segue.messageView.backgroundHeight = 240
        segue.messageView.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        segue.perform()
    }
    
    internal func presentUpdateVC(viewController: UIViewController) {
        let vc = UpdateViewController()
        vc.coordinator = self
        let segue = SwiftMessagesSegue(identifier: nil, source: viewController, destination: vc)
        segue.interactiveHide = true
        segue.dimMode = .blur(style: .dark, alpha: 0.5, interactive: false)
        segue.configure(layout: .centered)
        segue.messageView.backgroundHeight = 240
        segue.messageView.layoutMarginAdditions = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        segue.perform()
    }
}

//
//  OnboardingCoordinator.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 13/08/24.
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    
    internal var childCoordinators = [Coordinator]()
    internal var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = DescriptionsViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToTariffsVC() {
        let vc = TariffsViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    internal func pushToPaymentVC() {
        let vc = PaymentViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
}


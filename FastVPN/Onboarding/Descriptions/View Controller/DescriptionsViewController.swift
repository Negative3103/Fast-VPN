//
//  DescriptionsViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 13/08/24.
//

import UIKit

final class DescriptionsViewController: UIViewController, AlertViewController, ViewSpecificController {
    
    //MARK: - Root View
    typealias RootView = DescriptionsView
    
    //MARK: - Sources
    internal var coordinator: OnboardingCoordinator?
    
    //MARK: - Attributes
    private let dataProvider = DescriptionsDataProvider()
    
    //MARK: - Actions
    @IBAction func nextAction(_ sedner: UIButton) {
        coordinator?.pushToTariffsVC()
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
    }
}

//MARK: - Other funcs
extension DescriptionsViewController {
    private func appearanceSettings() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "newFastVpn".localized
        navigationController?.navigationBar.installBlurEffect()
        dataProvider.viewController = self
        dataProvider.collectionView = view().collectionView
    }
}

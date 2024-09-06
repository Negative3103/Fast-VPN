//
//  TariffsViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 13/08/24.
//

import UIKit

final class TariffsViewController: UIViewController, AlertViewController, ViewSpecificController {
    
    //MARK: - Root View
    typealias RootView = TariffsView
    
    //MARK: - Sources
    internal var coordinator: OnboardingCoordinator?

    //MARK: - Attributes
    private let dataProvider = TariffsDataProvider()
    internal var selectedTariff: TariffModel?
    
    //MARK: - Actions
    @IBAction func nextAction(_ sedner: UIButton) {
        coordinator?.pushToPaymentVC()
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
    }
}

//MARK: - Other funcs
extension TariffsViewController {
    private func appearanceSettings() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "chooseTariff".localized
        navigationController?.navigationBar.installBlurEffect()
        dataProvider.viewController = self
        dataProvider.tableView = view().tableView
    }
}

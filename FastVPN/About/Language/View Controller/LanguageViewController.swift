//
//  LanguageViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 16/06/24.
//

import UIKit

protocol LanguageViewControllerDelegate: NSObject {
    func didSelect()
}

final class LanguageViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    //MARK: - Root View
    typealias RootView = LanguageView
    
    //MARK: - Services
    internal var coordinator: AboutCoordinator?
    weak var delegate: LanguageViewControllerDelegate?
    
    //MARK: - Attributes
    private let dataProvider = LanguageDataProvider()
    internal let languages = LanguageModel.languages
    
    //MARK: - Actions
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
    }
    
}

//MARK: - Other funcs
extension LanguageViewController {
    private func appearanceSettings() {
        navigationController?.title = "chooseLanguage".localized
        navigationController?.navigationBar.installBlurEffect()
        dataProvider.viewController = self
        dataProvider.collectionView = view().collectionView
        dataProvider.items = languages
    }
    
    func didSelectLanguage(lang: String) {
        LocalizationManager.shared.setLocale(lang)
        delegate?.didSelect()
    }
}

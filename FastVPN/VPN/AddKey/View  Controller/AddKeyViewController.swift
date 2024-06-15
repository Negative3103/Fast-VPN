//
//  AddKeyViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 15/06/24.
//

import UIKit

protocol AddKeyViewControllerDelegate: NSObject {
    func didFinishKey()
}

final class AddKeyViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    //MARK: - Root View
    typealias RootView = AddKeyView
    
    //MARK: - Services
    internal var coordinator: VPNCoordinator?
    
    //MARK: - Attributes
    weak var delegate: AddKeyViewControllerDelegate?
    
    //MARK: - Actions
    @IBAction func buttonAction(_ sender: UIButton) {
        guard let text = view().keyTextField.text, !text.isEmpty else {
            showErrorAlert(message: "Заполните поле")
            return }
        UserDefaults.standard.setVpnKey(key: text)
        delegate?.didFinishKey()
        dismiss(animated: true)
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
    }
    
}

//MARK: - Other funcs
extension AddKeyViewController {
    private func appearanceSettings() {}
}


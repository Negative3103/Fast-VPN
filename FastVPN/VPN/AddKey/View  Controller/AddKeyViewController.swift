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
            showErrorAlert(message: "fill".localized)
            return }
        guard text.contains("ssconf://") else {
            showErrorAlert(message: "enterValidKey".localized)
            return }
        UserDefaults.standard.setVpnKey(key: text)
        delegate?.didFinishKey()
        dismiss(animated: true)
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
        closeKeyboardOnOutsideTap()
        view().keyTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkClipboard()
    }

}

//MARK: - Other funcs
extension AddKeyViewController {
    private func appearanceSettings() {
        view().keyTextField.delegate = self
    }
    
    @objc private func checkClipboard() {
        if let clipboardText = UIPasteboard.general.string {
            view().keyTextField.text = clipboardText
        }
    }
}

//MARK: - UITextFieldDelegate
extension AddKeyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}

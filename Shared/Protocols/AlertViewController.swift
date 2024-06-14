//
//  AlertViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit
import SwiftMessages

protocol AlertViewController {
    func showAlert(title: String, message: String, buttonAction: (()->())?)
    func showAlertWithTwoButtons(title: String, message: String, firstButtonText: String, firstButtonAction: (()->())?, secondButtonText: String, secondButtonAction: (()->())?)
}

extension AlertViewController where Self: UIViewController {
    func showAlert(title: String, message: String, buttonAction: (()->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.default, handler: { (action) in
            buttonAction?()
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertWithTwoButtons(title: String, message: String, firstButtonText: String, firstButtonAction: (()->())? = nil, secondButtonText: String, secondButtonAction: (()->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: firstButtonText, style: UIAlertAction.Style.default, handler: { (action) in
            firstButtonAction?()
        }))
        alert.addAction(UIAlertAction(title: secondButtonText, style: UIAlertAction.Style.default, handler: { (action) in
            secondButtonAction?()
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertDestructive(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .actionSheet, buttonTitle: String, _ buttonAction: (() -> Void)? = nil) {
        var preferredStyle = preferredStyle
        if (UIDevice.current.userInterfaceIdiom == .pad) { preferredStyle = UIAlertController.Style.alert }
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: buttonTitle, style: .destructive, handler: { _ in
            buttonAction?()
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension AlertViewController where Self: UIViewController {
    func showErrorAlert(title: String = "Ошибка", message: String? = nil) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Ошибка", body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Ок", buttonTapHandler: { _ in SwiftMessages.hide() })
        view.configureTheme(.error, iconStyle: .default)
        view.accessibilityPrefix = "error"
        view.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .automatic
        SwiftMessages.show(config: config, view: view)
    }
    
    func showWarningAlert(title: String = "Внимание", message: String? = nil, duration: SwiftMessages.Duration = .automatic, tapHandler : ((_ view: BaseView) -> Void)? = nil) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: "Внимание", body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Ок", buttonTapHandler: { _ in SwiftMessages.hide() })
        view.configureTheme(.warning, iconStyle: .default)
        view.accessibilityPrefix = "warning"
        view.titleLabel?.isHidden = true
        view.button?.isHidden = true
        view.tapHandler = tapHandler
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = duration
        SwiftMessages.show(config: config, view: view)
    }
    
    func showSuccessAlert(title: String = "Успешно", message: String? = nil) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Ок", buttonTapHandler: { _ in SwiftMessages.hide() })
        view.configureTheme(.success, iconStyle: .default)
        view.accessibilityPrefix = "Успешно"
        view.button?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .automatic
        SwiftMessages.show(config: config, view: view)
    }
}

//
//  UIViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

extension UIViewController {
    func openURL(urlString : String) {
        guard let selectedURL = URL(string: urlString) else { return }
        if UIApplication.shared.canOpenURL(selectedURL) {
            UIApplication.shared.open(selectedURL, options: [:], completionHandler: nil)
        }
    }
    
    @objc open func dismissKeyboard() {
        view.endEditing(true)
    }

    internal func closeKeyboardOnOutsideTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func resetTabBarTransition() {
        guard let window = UIApplication.shared.windows.first, let tabBarController = self.tabBarController else {
            return
        }
        
        let newTabBarController = TabBarController()
        newTabBarController.selectedIndex = tabBarController.selectedIndex
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = newTabBarController
        }, completion: nil)
    }
}

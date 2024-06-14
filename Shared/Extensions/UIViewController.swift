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
}

//
//  ViewModelProtocol.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 17/06/24.
//

import UIKit

protocol ViewModelProtocol: NSObject {
    
    // MARK: - Attributes
    var customSpinnerView: CustomSpinnerView { get }
    
    func showActivityIndicator()
    func hideActivityIndicator()
}

extension ViewModelProtocol where Self: UIViewController {
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            self.customSpinnerView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(self.customSpinnerView)
            self.customSpinnerView.tintColor = UIColor.appColor(.black)
            NSLayoutConstraint.activate([
                self.customSpinnerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.customSpinnerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
            self.customSpinnerView.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        self.customSpinnerView.stopAnimating()
        self.customSpinnerView.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }
    
}

//
//  AddKeyView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 15/06/24.
//

import UIKit

final class AddKeyView: CustomView {
    
    //MARK: - Outlets
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var button: HighlightButton! {
        didSet {
            button.setBorder(enable: true, borderWidth: 1.5, color: .white)
            button.layer.cornerRadius = 16
        }
    }
    @IBOutlet weak var keyView: UIView! {
        didSet {
            keyView.layer.cornerRadius = 16
        }
    }
}

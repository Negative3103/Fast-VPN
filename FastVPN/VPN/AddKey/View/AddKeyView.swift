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
            button.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var keyView: UIView! {
        didSet {
            keyView.layer.cornerRadius = 10
        }
    }
}

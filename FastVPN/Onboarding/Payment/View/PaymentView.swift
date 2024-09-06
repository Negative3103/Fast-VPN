//
//  PaymentView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 13/08/24.
//

import UIKit

final class PaymentView: CustomView {
    
    //MARK: - Outlets
    @IBOutlet weak var appleButton: HighlightButton! {
        didSet {
            appleButton.layer.cornerRadius = 16
            appleButton.setBorder(enable: true, borderWidth: 1.5, color: .white)
        }
    }
    @IBOutlet weak var tgButton: HighlightButton! {
        didSet {
            tgButton.layer.cornerRadius = 16
            tgButton.setBorder(enable: true, borderWidth: 1.5, color: .white)
        }
    }
    @IBOutlet weak var nextButton: HighlightButton! {
        didSet {
            nextButton.layer.cornerRadius = 16
            nextButton.setBorder(enable: true, borderWidth: 1.5, color: .white)
        }
    }
    
    //MARK: - Lifecycles
    override func layoutSubviews() {
        super.layoutSubviews()
        tgButton.isHidden = !UserDefaults.standard.isFromRestrictedCountry()
    }
}

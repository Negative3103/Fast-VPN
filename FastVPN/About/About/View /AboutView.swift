//
//  AboutView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

final class AboutView: CustomView {
    
    //MARK: - Outlets
    @IBOutlet weak var versionLabel: UILabel! {
        didSet {
            guard let version = Bundle.main.releaseVersionNumber else {return}
            versionLabel.text = "version".localized + Symbols.space.rawValue + version
        }
    }
    @IBOutlet var views: [UIView]! {
        didSet {
            views.forEach({ $0.layer.cornerRadius = 10 })
        }
    }
}

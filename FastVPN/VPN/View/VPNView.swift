//
//  VPNView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

final class VPNView: CustomView {
    
    //MARK: - Outlets
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var supportButton: HighlightButton! {
        didSet {
            supportButton.setBorder(enable: true, borderWidth: 2)
            supportButton.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var settingsButton: HighlightButton! {
        didSet {
            settingsButton.layer.cornerRadius = 10
        }
    }
    lazy var addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setImage(.appImage(.plus), for: .normal)
        button.tintColor = .white
        return button
    }()
}

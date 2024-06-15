//
//  VPNView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

final class VPNView: UIView {
    
    //MARK: - Outlets
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ballBtn: UIButton!
    @IBOutlet weak var viewFirst: UIImageView! {
        didSet {
            viewFirst.layer.cornerRadius = viewFirst.frame.width / 2
        }
    }
    @IBOutlet weak var viewSecond: UIImageView! {
        didSet {
            viewSecond.layer.cornerRadius = viewSecond.frame.width / 2
        }
    }
    @IBOutlet weak var viewThird: UIImageView! {
        didSet {
            viewThird.layer.cornerRadius = viewThird.frame.width / 2
        }
    }
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

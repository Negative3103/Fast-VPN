//
//  VPNView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit
import DeviceKit
import SnapKit

final class VPNView: CustomView {
    
    //MARK: - Outlets
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var ballBtn: UIButton!
    @IBOutlet weak var supportButton: HighlightButton! {
        didSet {
            supportButton.setBorder(enable: true, borderWidth: 1.5, color: .white)
            supportButton.layer.cornerRadius = 16
        }
    }
    @IBOutlet weak var settingsButton: HighlightButton! {
        didSet {
            settingsButton.setBorder(enable: true, borderWidth: 1.5, color: .white)
            settingsButton.layer.cornerRadius = 16
        }
    }
    
    //MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        settingsButton.isHidden = !UserDefaults.standard.isFromRestrictedCountry()
    }
}

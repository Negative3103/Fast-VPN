//
//  AboutView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

final class AboutView: CustomView {
    
    //MARK: - Outlets
    @IBOutlet weak var dateView: UIView! {
        didSet {
            dateView.layer.cornerRadius = 6
            dateView.setBorder(enable: true, borderWidth: 1.5, color: .white)
        }
    }
    @IBOutlet weak var versionLabel: UILabel! {
        didSet {
            guard let version = Bundle.main.releaseVersionNumber else {return}
            versionLabel.text = "version".localized + Symbols.space.rawValue + version
        }
    }
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var views: [UIView]! {
        didSet {
            views.forEach({
                $0.layer.cornerRadius = 6
                $0.setBorder(enable: true, borderWidth: 1.5, color: .white)
            })
        }
    }
    
    lazy var addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setImage(.appImage(.plus), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    //MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        views[1].isHidden = !UserDefaults.standard.isFromRestrictedCountry()
    }
}

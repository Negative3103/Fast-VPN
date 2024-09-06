//
//  VPNView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit
import Lottie
import DeviceKit
import SnapKit

final class VPNView: CustomView {
    
    //MARK: - Outlets
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var ballBtn: UIButton!
    @IBOutlet weak var animationView: UIView! {
        didSet {
            animationView.layer.cornerRadius = animationView.frame.width / 2
        }
    }
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
    
    //MARK: - Other funcs
    func animate(animation: LottieAnimation, viewController: VPNViewController) {
        let loadingView = LottieAnimationView(name: animation.rawValue)
        loadingView.contentMode = .scaleAspectFit
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.loopMode = .loop
        loadingView.backgroundBehavior = .pauseAndRestore
        
        loadingView.addGestureRecognizer(UITapGestureRecognizer(target: viewController, action: #selector(viewController.connectVpn)))
        
        animationView.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.edges.equalTo(animationView)
        }
        
        loadingView.play()
    }
    
    //MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        settingsButton.isHidden = !UserDefaults.standard.isFromRestrictedCountry()
    }
}

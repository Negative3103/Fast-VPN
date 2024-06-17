//
//  VPNView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit
import Lottie

final class VPNView: UIView {
    
    //MARK: - Outlets
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ballBtn: UIButton!
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var animationView: UIView! {
        didSet {
            animationView.layer.cornerRadius = animationView.frame.width / 2
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
}

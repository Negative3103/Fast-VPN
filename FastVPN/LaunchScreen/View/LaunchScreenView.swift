//
//  LaunchScreenView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 15/06/24.
//

import UIKit
import Lottie
import SnapKit

final class LaunchScreenView: UIView {
    
    //MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    func animate(completion: LottieCompletionBlock? = nil) {
        let loadingView = LottieAnimationView(name: LottieAnimation.lightning.rawValue)
        loadingView.contentMode = .scaleAspectFit
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.loopMode = .playOnce
        
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(400)
        }
        
        loadingView.play(completion: completion)
    }
}

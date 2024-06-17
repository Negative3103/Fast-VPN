//
//  CustomSpinnerView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 17/06/24.
//

import UIKit

final class CustomSpinnerView: UIView {
    
    fileprivate var stopped: Bool = false
    
    /// true if the loader should be hidden when it is not animating, default = true
    internal var hidesWhenStopped: Bool = true
    
    /// The color of the loader view
    override var tintColor: UIColor! {
        didSet {
            guard tintColor != nil else { return }
            for sublayer in layer.sublayers! {
                let _sublayer = sublayer
                
                _sublayer.backgroundColor = tintColor.cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8.0
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 100.0),
            self.widthAnchor.constraint(equalToConstant: 100.0)
        ])
        setupAnimation(layer, size: CGSize(width: 80.0, height: 80.0), color: tintColor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 8.0
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 100.0),
            self.widthAnchor.constraint(equalToConstant: 100.0)
        ])
        setupAnimation(layer, size: CGSize(width: 80.0, height: 80.0), color: tintColor)
    }
    
    /**
    * Start animating the loader view
    */
    internal func startAnimating() {
        if !isAnimating() {
            stopped = false
            isHidden = false
            resumeLayers()
        }
    }
    
    /**
    * Stop animating the loader view
    * if hidesWhenStopped = true then the loader will be hidden as well
    */
    internal func stopAnimating() {
        if isAnimating() {
            if hidesWhenStopped {
                isHidden = true
            }
            stopped = true
            pauseLayers()
        }
    }
    
    /**
    * returns true if the loader is animating
    */
    internal func isAnimating() -> Bool {
        return !stopped
    }
    
    private func resumeLayers() {
        let pausedTime = layer.timeOffset
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        layer.beginTime = timeSincePause
    }
    
    private func pauseLayers() {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    private func setupAnimation(_ layer: CALayer, size: CGSize, color: UIColor) {
        let beginTime = CACurrentMediaTime()
        
        let offset: CGFloat = size.width / 8
        let circleSize: CGFloat = offset * 2
        
        for i in 0..<3 {
            
            let circleX = (CGFloat(i) * 3 * offset) + 10.0
            let circleY = (size.height / 2 - circleSize / 2) + 10.0
            
            let circle = CALayer()
            circle.frame = CGRect(x: circleX, y: circleY, width: circleSize, height: circleSize)
            circle.backgroundColor = color.cgColor
            circle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            circle.cornerRadius = circle.bounds.height * 0.5
            circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            
            let anim = CAKeyframeAnimation(keyPath: "transform")
            anim.isRemovedOnCompletion = false
            anim.repeatCount = Float.infinity
            anim.duration = 1
            anim.beginTime = beginTime + CFTimeInterval(0.25 * CGFloat(i))
            anim.keyTimes = [0.0, 0.5, 1.0]
            
            anim.timingFunctions = [
                CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
                CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),
                CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            ]
            
            anim.values = [
                NSValue(caTransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)),
                NSValue(caTransform3D:CATransform3DMakeScale(1.0, 1.0, 0.0)),
                NSValue(caTransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0))
            ]
            
            layer.addSublayer(circle)
            circle.add(anim, forKey: "anime")
        }
    }
}

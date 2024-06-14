//
//  HighlightButton.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

final class HighlightButton: UIButton {
    
    @IBInspectable var highlightedBackgroundColor: UIColor?
    
    @IBInspectable var normalBackgroundColor: UIColor? {
        didSet {
            backgroundColor = normalBackgroundColor
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            animateBackground(to: isHighlighted ? highlightedBackgroundColor : normalBackgroundColor, duration: 0.1)
        }
    }
    
    private func animateBackground(to color: UIColor?, duration: TimeInterval) {
        guard let color = color else { return }
        UIView.animate(withDuration: duration) {
            self.backgroundColor = color
        }
    }
}

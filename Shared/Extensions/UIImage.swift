//
//  UIImage.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

extension UIImage {
    static func appImage(_ named: AppImages) -> UIImage {
        return UIImage(named: named.rawValue) ?? UIImage()
    }
}

//
//  UIColor.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

extension UIColor {
    static func appColor(_ named: AppColors) -> UIColor {
        return UIColor(named: named.rawValue) ?? .clear
    }
}

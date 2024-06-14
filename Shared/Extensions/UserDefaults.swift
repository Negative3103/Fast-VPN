//
//  UserDefaults.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

enum UserDefaultsKeys: String {
    case vpnKey
}

extension UserDefaults {
    func setVpnKey(key: String) {
        set(key, forKey: UserDefaultsKeys.vpnKey.rawValue)
    }
    
    func getVpnKey() -> String? {
        return string(forKey: UserDefaultsKeys.vpnKey.rawValue)
    }
}

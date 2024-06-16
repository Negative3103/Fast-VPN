//
//  UserDefaults.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

enum UserDefaultsKeys: String {
    case vpnKey
    case server
}

extension UserDefaults {
    func setVpnKey(key: String) {
        set(key, forKey: UserDefaultsKeys.vpnKey.rawValue)
    }
    
    func getVpnKey() -> String? {
        return string(forKey: UserDefaultsKeys.vpnKey.rawValue)
    }
    
    func removeVpnKey() {
        removeObject(forKey: UserDefaultsKeys.vpnKey.rawValue)
    }
    
    func setVpnServer(server: String) {
        set(server, forKey: UserDefaultsKeys.server.rawValue)
    }
    
    func getVpnServer() -> String? {
        return string(forKey: UserDefaultsKeys.server.rawValue)
    }
    
    func removeVpnServer() {
        removeObject(forKey: UserDefaultsKeys.server.rawValue)
    }
}

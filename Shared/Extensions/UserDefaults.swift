//
//  UserDefaults.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

enum AppLanguage: String {
    case ru
    case en
}

enum UserDefaultsKeys: String {
    case localization
    case vpnKey
    case server
}

extension UserDefaults {
    func getLocalization() -> String {
        return string(forKey: UserDefaultsKeys.localization.rawValue) ?? AppLanguage.ru.rawValue
    }

    func saveLocalization(lang: String) {
        set(lang, forKey: UserDefaultsKeys.localization.rawValue)
    }
    
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

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
    case hasServer
    case isFromRestrictedCountry
    case isChecked
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
    
    func setHasServer(hasServer: Bool) {
        set(hasServer, forKey: UserDefaultsKeys.hasServer.rawValue)
    }
    
    func isHasServer() -> Bool {
        return bool(forKey: UserDefaultsKeys.hasServer.rawValue) 
    }
    
    func removeHasServer() {
        removeObject(forKey: UserDefaultsKeys.hasServer.rawValue)
    }
    
    func isFromRestrictedCountry(isFromRestrictedCountry: Bool) {
        set(isFromRestrictedCountry, forKey: UserDefaultsKeys.isFromRestrictedCountry.rawValue)
    }
    
    func isFromRestrictedCountry() -> Bool {
        return bool(forKey: UserDefaultsKeys.isFromRestrictedCountry.rawValue)
    }
    
    func setIsChecked(isChecked: Bool) {
        set(isChecked, forKey: UserDefaultsKeys.isChecked.rawValue)
    }
    
    func isChecked() -> Bool? {
        return bool(forKey: UserDefaultsKeys.isChecked.rawValue)
    }
}

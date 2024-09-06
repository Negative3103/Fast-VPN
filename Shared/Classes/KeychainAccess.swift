//
//  KeychainAccess.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 13/08/24.
//

import KeychainAccess
import UIKit

enum KeychainKeys: String {
    case firstLaunch
}

final class KeychainAccessCheck: NSObject {
    
    static let keychain = Keychain(service: MainConstants.service.rawValue)
    
    class func isFirstLaunch() -> Bool {
        return firstLaunch() == nil ? true : false
    }
    
    class func saveFirstLaunch() {
        do {
            try keychain.set(KeychainKeys.firstLaunch.rawValue, key: KeychainKeys.firstLaunch.rawValue)
        }
        catch let error {
            print("error: \(error)")
        }
    }
    
    class func firstLaunch() -> String? {
        do {
            return try keychain.get(KeychainKeys.firstLaunch.rawValue)
        } catch let error {
            print("error: \(error)")
            return nil
        }
    }
    
    class func removeFirstLaunch() {
        do {
            try keychain.remove(KeychainKeys.firstLaunch.rawValue)
        } catch let error {
            print("error: \(error)")
        }
    }
    
}

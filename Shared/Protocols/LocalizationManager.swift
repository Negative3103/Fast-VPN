//
//  LocalizationManager.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 16/06/24.
//

import UIKit

class LocalizationManager: NSObject {
    static let shared = LocalizationManager()

    var currentLocalizationBundle = Bundle.main

    override init() {
        super.init()
        getCurrentBundle()
    }

    func getCurrentBundle() {
        if let bundleStr = Bundle.main.path(forResource: UserDefaults.standard.getLocalization(), ofType: "lproj"),
            let bundle = Bundle(path: bundleStr) {
            self.currentLocalizationBundle = bundle
        }
    }

    func setLocale(_ language: String) {
        UserDefaults.standard.saveLocalization(lang: language)
        getCurrentBundle()
    }

    func getLocale() -> String {
        return UserDefaults.standard.getLocalization()
    }
}

protocol Localizable {
    var localized: String { get }
}

protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: LocalizationManager.shared.currentLocalizationBundle, value: "", comment: "")
    }
}

extension UILabel: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}
extension UIButton: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
   }
}
extension UITextField: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localized
        }
   }
}

struct LocalizedString: ExpressibleByStringLiteral, Equatable {

    let v: String

    init(key: String) {
        self.v = key.localized
    }
    init(localized: String) {
        self.v = localized
    }
    init(stringLiteral value:String) {
        self.init(key: value)
    }
    init(extendedGraphemeClusterLiteral value: String) {
        self.init(key: value)
    }
    init(unicodeScalarLiteral value: String) {
        self.init(key: value)
    }
}

func ==(lhs:LocalizedString, rhs:LocalizedString) -> Bool {
    return lhs.v == rhs.v
}

//
//  AppDelegate.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .appColor(.mainBackground)
        window?.rootViewController = UINavigationController(rootViewController: LaunchScreenViewController())
        window?.makeKeyAndVisible()    
        
        return true
    }

}


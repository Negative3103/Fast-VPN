//
//  AppDelegate.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit
import CocoaLumberjackSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    internal var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DDLog.add(DDOSLogger.sharedInstance)
        DDLog.add(AlertLogger.sharedInstance)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .appColor(.mainBackground)
        window?.rootViewController = UINavigationController(rootViewController: LaunchScreenViewController())
        window?.makeKeyAndVisible()    
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL?.absoluteString
            let lastDigits = url?.components(separatedBy: "/").last ?? ""
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                Notification.Name.universalLink.post(object: String(lastDigits))
            }
        }
        return true
    }
    
}


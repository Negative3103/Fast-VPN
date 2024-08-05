//
//  AppDelegate.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseMessaging
import UserNotifications
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
        
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        
        Messaging.messaging().delegate = self
        registerForPushNotifications()

        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL?.absoluteString
            let lastDigits = url?.components(separatedBy: "/").last ?? ""
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                Notification.Name.universalLink.post(object: String(lastDigits))
            }
        }
        return true
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let vc = (application.topViewController() as? VPNViewController) else { return }
        vc.checkStatus()
    }
    
}

// MARK: - Delegates
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().subscribe(toTopic: "all")
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { (token, error) in
            if let error = error {
                print(error)
            } else if let token = token {
                print(token)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        process(response.notification)
        completionHandler()
    }

    private func process(_ notification: UNNotification) {
        print("some funcs")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([[.banner, .sound]])
        } else {
            completionHandler([[.alert, .sound]])
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed: \(error)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("Firebase Registration Token \(fcmToken)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.newData)
        
        switch application.applicationState {
        case .active:
            print("active \(userInfo)")
        case .background:
            print("background \(userInfo)")
        case .inactive:
            print("inactive \(userInfo)")
        @unknown default:
            print("unknown")
        }
    }
}

extension AppDelegate {
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self.getNotificationSettings()
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

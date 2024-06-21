//
//  AlertLogger.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 21/06/24.
//

import CocoaLumberjack
import CocoaLumberjackSwift

final class AlertLogger: DDAbstractLogger {
    
    static let sharedInstance = AlertLogger()
    
    private override init() {}
    
    override func log(message logMessage: DDLogMessage) {
        if logMessage.flag.contains(.error) {
            DispatchQueue.main.async {
                if let topController = UIApplication.shared.keyWindow?.rootViewController {
                    var currentController = topController
                    while let presentedController = currentController.presentedViewController {
                        currentController = presentedController
                    }
                    self.showAlert(message: logMessage.message, viewController: currentController)
                }
            }
        }
    }
    
    func showAlert(message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}

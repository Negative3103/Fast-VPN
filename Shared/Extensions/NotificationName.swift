//
//  NotificationName.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 18/06/24.
//

import Foundation

enum UserInfoName: String {
    case unreadCount
}

extension Notification.Name {
    static let deleteUrl = Notification.Name(rawValue: "deleteUrl")
    static let universalLink = Notification.Name(rawValue: "universalLink")
    static let startVPN = Notification.Name(rawValue: "startVPN")
    static let connectKey = Notification.Name(rawValue: "connectKey")
    static let getData = Notification.Name(rawValue: "getData")
    static let noInternet = Notification.Name(rawValue: "noInternet")
    
    func post(object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
    }
    
    @discardableResult
    func onPost(object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: self, object: object, queue: queue, using: using)
    }
}

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
    
    func post(object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: self, object: object, userInfo: userInfo)
    }
    
    @discardableResult
    func onPost(object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: self, object: object, queue: queue, using: using)
    }
}

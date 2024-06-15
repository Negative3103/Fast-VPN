//
//  URLRequest.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 15/06/24.
//

import Foundation

extension URLRequest {
    // MARK: - JSON
    mutating func setJSONParameters(_ parameters: [String: Any]?) {
        guard let parameters = parameters else {
            httpBody = nil
            return
        }
        
        httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))
    }
}

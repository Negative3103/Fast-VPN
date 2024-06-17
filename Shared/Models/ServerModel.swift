//
//  ServerModel.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 16/06/24.
//

import Foundation

struct ServerModel: Codable {
    var server: String?
    var serverPort: Int?
    var password: String?
    var method: String?
    var prefix: String?
    
    public func returnJSON() -> [String: Any] {
        let jsonData = [
            "host": self.server ?? "",
            "port": self.serverPort ?? 0,
            "method":  self.method ?? "",
            "password": self.password ?? "",
            "prefix": self.prefix ?? ""
        ] as [String : Any]
        
        return jsonData
    }
}

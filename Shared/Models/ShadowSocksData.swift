//
//  ShadowSocksData.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 15/06/24.
//

import UIKit

public class ShadowSocksData {
    var host: String?
    var port: Int?
    var method: String?
    var password: String?
    var prefix: String?
    
    init(host: String? = nil, port: Int? = nil, method: String? = nil, password: String? = nil, prefix: String? = nil) {
        self.host = host
        self.port = port
        self.method = method
        self.password = password
        self.prefix = prefix
    }
    
    public func returnJSON() -> [String: Any] {
        let jsonData = [
            "host": self.host ?? "",
            "port": self.port ?? 0,
            "method":  self.method ?? "",
            "password": self.password ?? "",
            "prefix": self.prefix ?? ""
        ] as [String : Any]
        
        return jsonData
    }
}

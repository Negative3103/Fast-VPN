//
//  VPNViewModel.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import Foundation

final class VPNViewModel {
    func parseShadowsocksURL(_ url: String) -> ShadowSocksData? {
        guard let urlComponents = URLComponents(string: url) else { return nil }
        
        // Получаем информацию о методе шифрования и пароле из закодированной строки
        guard let encodedEncryptionAndKey = urlComponents.user else { return nil }
        guard let decodedEncryptionAndKeyData = Data(base64Encoded: encodedEncryptionAndKey) else { return nil }
        guard let decodedEncryptionAndKey = String(data: decodedEncryptionAndKeyData, encoding: .utf8) else { return nil }
        
        // Разбиваем информацию о методе шифрования и пароле по символу :
        let encryptionAndKeyComponents = decodedEncryptionAndKey.components(separatedBy: ":")
        // Если разбиение не дало две части, значит URL неверный
        guard encryptionAndKeyComponents.count == 2 else { return nil }

        // Получаем метод шифрования и пароль
        let encryptionMethod = encryptionAndKeyComponents[0]
        let password = encryptionAndKeyComponents[1]

        // Получаем адрес сервера и порт
        guard let server = urlComponents.host else { return nil }
        guard let port = urlComponents.port.flatMap({ String($0) }) else { return nil }

        // Возвращаем словарь с полученными данными
        return ShadowSocksData(host: server, port: port, encryptionMethod: encryptionMethod, password: password)
    }
}

public class ShadowSocksData {
    var host: String
    var port: String
    var encryptionMethod: String
    var password: String
    
    init(host: String, port: String, encryptionMethod: String, password: String) {
        self.host = host
        self.port = port
        self.encryptionMethod = encryptionMethod
        self.password = password
    }
    
    public func returnJSON() -> [String: Any] {
        let jsonData = [
            "host": self.host,
            "port": self.port,
            "method":  self.encryptionMethod,
            "password": self.password
        ]
        
        return jsonData
    }
}

//
//  VPNViewModel.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import Foundation

protocol VPNViewModelProtocol: NSObject {
    func didFinishFetch(configJson: ShadowSocksData)
}

final class VPNViewModel {
    
    // MARK: - Attributes
    weak var delegate: VPNViewModelProtocol?
    
    // MARK: - Network call
    internal func connect(url: String) {
        JSONDownloader.shared.jsonTask(url: url, requestMethod: .get, completionHandler: { [weak self]  (result) in
            guard let self = self else { return }
            switch result {
            case .Error(let error):
                print(error)
            case .Success(let json):
                do {
                    if let json = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] {
                        guard let server = json["server"] as? String,
                              let serverPort = json["server_port"] as? Int,
                              let password = json["password"] as? String,
                              let method = json["method"] as? String,
                              let prefix = json["prefix"] as? String else { return }
                        self.delegate?.didFinishFetch(configJson: ShadowSocksData(host: server, port: serverPort, method: method, password: password, prefix: prefix))
                    }
                } catch {
                    print(APIError.invalidData)
                }
            }
        })
    }
}

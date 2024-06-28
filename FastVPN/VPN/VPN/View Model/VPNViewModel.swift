//
//  VPNViewModel.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import Foundation
import UIKit

protocol VPNViewModelProtocol: ViewModelProtocol {
    func didFinishFetch(configJson: ShadowSocksData)
    func didFinishFetch(server: ServerModel?, endDate: String?, serverName: String?, message: String?)
    func didFinishFetchRegistration(server: ServerModel?, endDate: String?, serverName: String?, message: String?)
}

final class VPNViewModel {
    
    // MARK: - Attributes
    weak var delegate: VPNViewModelProtocol?
    var uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
    
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
    
    internal func getServerInfo() {
        delegate?.showActivityIndicator()
        JSONDownloader.shared.jsonTask(url: EndPoints.server.rawValue + uuid, requestMethod: .get, completionHandler: { [weak self]  (result) in
            guard let self = self else { return }
            switch result {
            case .Error(let error):
                print(error)
            case .Success(let json):
                do {
                    let fetchedData = try CustomDecoder().decode(JSONDataRegistration<ServerModel>.self, from: json)
                    self.delegate?.didFinishFetch(server: fetchedData.token, endDate: fetchedData.tokenEndDate, serverName: fetchedData.server, message: fetchedData.message)
                } catch {
                    print(APIError.invalidData)
                }
            }
            self.delegate?.hideActivityIndicator()
        })
    }
    
    internal func registration(clientId: String) {
        
        var params: [String: Any] = [
            "appUuid" : uuid,
            "clientId" : clientId
        ]
        
        delegate?.showActivityIndicator()
        JSONDownloader.shared.jsonTask(url: EndPoints.registration.rawValue, requestMethod: .post, parameters: params, completionHandler: { [weak self]  (result) in
            guard let self = self else { return }
            switch result {
            case .Error(let error):
                print(error)
            case .Success(let json):
                do {
                    let fetchedData = try CustomDecoder().decode(JSONDataRegistration<ServerModel>.self, from: json)
                    self.delegate?.didFinishFetchRegistration(server: fetchedData.token, endDate: fetchedData.tokenEndDate, serverName: fetchedData.server, message: fetchedData.message)
                } catch {
                    print(APIError.invalidData)
                }
            }
            self.delegate?.hideActivityIndicator()
        })
    }
    
    func fetchIPAddress(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://api64.ipify.org?format=json") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            if let ipResponse = try? JSONDecoder().decode(IPResponse.self, from: data) {
                completion(ipResponse.ip)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func fetchLocation(ip: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://ipapi.co/\(ip)/json/") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            if let locationResponse = try? JSONDecoder().decode(LocationResponse.self, from: data) {
                completion(locationResponse.country)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

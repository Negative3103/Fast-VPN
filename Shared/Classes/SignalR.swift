//
//  SignalR.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 06/08/24.
//

import Foundation
import SignalRClient
import UIKit

enum SignalRManager {
    //MARK: - Type Properties
    static let signalRManager: SignalRProtocol = SignalR()
}

protocol SignalRProtocol {
    func connect()
    func disconnect()
    func getMessage()
}

protocol SignalRDelegate: NSObject {
    func getMessage(message: String)
}

class SignalR: NSObject, SignalRProtocol {
        
    //MARK: - Sources
    private var connection: HubConnection?
    weak var hubConnectionDelegate: HubConnectionDelegate?
    weak var delegate: SignalRDelegate?
    
    //MARK: - Attributes
    
    //MARK: - Lifecycles
    override init() {
        super.init()
        hubConnectionDelegate = self
        connection = HubConnectionBuilder(url: URL(string: MainConstants.signalRUrl.rawValue) ?? URL(fileURLWithPath: ""))
            .withHubConnectionDelegate(delegate: hubConnectionDelegate!)
            .withAutoReconnect()
            .withLogging(minLogLevel: .debug)
            .withHubConnectionOptions(configureHubConnectionOptions: { options in options.keepAliveInterval = 20 })
            .build()
    }
    
    //MARK: - Funcs
    func connect() {
        connection?.start()
    }
    
    func disconnect() {
        connection?.stop()
    }
    
    func getMessage() {
        connection?.on(method: "Message", callback: { (user: String, message: String) in
            self.delegate?.getMessage(message: message)
        })
    }
    
}

//MARK: - HubConnectionDelegate
extension SignalR: HubConnectionDelegate {
    func connectionDidOpen(hubConnection: SignalRClient.HubConnection) {
        print(hubConnection.connectionId)
    }
    
    func connectionDidFailToOpen(error: Error) {
        print(error.localizedDescription)
    }
    
    func connectionDidClose(error: Error?) {
        print(error?.localizedDescription)
    }
}

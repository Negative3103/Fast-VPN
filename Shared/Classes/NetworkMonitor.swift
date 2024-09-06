//
//  NetworkMonitor.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 06/09/24.
//

import Network
import UIKit

enum ConnectionType {
    case wifi
    case cellular
    case ethernet
    case unknown
}

class NetworkMonitor {
    
    //MARK: - Sources
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    //MARK: - Attributes
    var isConnected: Bool = false
    var connectionType: ConnectionType = .unknown
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    //MARK: - Protocols
    var onConnected: (() -> Void)?
    var onDisconnected: (() -> Void)?
    var onConnectionTypeChanged: ((ConnectionType) -> Void)?
    
    //MARK: - Lifecycles
    private init() {
        monitor.pathUpdateHandler = { path in
            let previousConnectionType = self.connectionType
            self.isConnected = path.status == .satisfied
            self.getConnectionType(path)
            
            if path.status == .satisfied {
                if previousConnectionType != self.connectionType {
                    self.onConnectionTypeChanged?(self.connectionType)
                }
                self.onConnected?()
            } else {
                self.onDisconnected?()
            }
            
            print("Connection Type: \(self.connectionType)")
        }
        monitor.start(queue: queue)
    }
    
    //MARK: - Open funcs
    func startMonitoring() {
        monitor.start(queue: queue)
        registerBackgroundTask()
    }
    
    func stopMonitoring() {
        monitor.cancel()
        endBackgroundTask()
    }
    
    //MARK: - Private funcs
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
    
    private func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        
        DispatchQueue.global(qos: .background).async {
            while UIApplication.shared.backgroundTimeRemaining > 1 {
                sleep(1)
            }
            self.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
}

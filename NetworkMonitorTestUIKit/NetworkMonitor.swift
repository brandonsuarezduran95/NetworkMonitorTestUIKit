//
//  NetworkMonitor.swift
//  NetworkMonitorTestUIKit
//
//  Created by Brandon Suarez on 11/17/23.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    public private(set) var connectionType: ConnectionType = .unknown

    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [unowned self] path in
            self.isConnected = path.status == .satisfied
            self.getConnectionType(path)
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType( _ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        }
        else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        }
        else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        }
        else {
            connectionType = .unknown
        }
    }
}

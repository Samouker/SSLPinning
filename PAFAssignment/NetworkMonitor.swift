//
//  NetworkMonitor.swift
//  PAFAssignment
//
//  Created by Rajan on 15/04/24.
//

import Foundation
import Network

typealias NetworkStatusHandler = (Bool) -> Void

// NetworkMonitor class for monitoring network connectivity
class NetworkMonitor {
    // Singleton instance
    static let shared = NetworkMonitor()
    
    private var observers = [String: NetworkStatusHandler]()
    
    private let queue = DispatchQueue.global()
    private let monitor = NWPathMonitor()
    
    // Boolean indicating network connectivity status
    var isConnected: Bool = false
    
    // Private initializer to prevent external initialization
    private init() {
        
    }
    
    // Function to add observer with a block
    func addObserver(forController controller: AnyClass, handler: @escaping NetworkStatusHandler) {
        let controllerID = String(describing: controller)
        observers[controllerID] = handler
        // Call the handler immediately with the current network status
        // handler(isConnected)
    }
    
    // Function to remove observer for a specific controller
    func removeObserver(forController controller: AnyClass) {
        let controllerID = String(describing: controller)
        observers.removeValue(forKey: controllerID)
    }
    
    
    // Function to start network monitoring
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            
            let isConnected = path.status == .satisfied
            
            if self.isConnected != isConnected{
                self.isConnected = isConnected
                self.notifyObservers()
            }
        }
        
        let queue = DispatchQueue(label: "PAF_NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    // Function to stop network monitoring
    func stopMonitoring() {
        // Cancel monitoring
        monitor.cancel()
    }
    
    // Function to notify all registered observers
    private func notifyObservers() {
        for observer in observers.values {
            observer(isConnected)
        }
    }
}

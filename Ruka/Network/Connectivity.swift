//
//  File.swift
//  BidServiceCust
//
//  Created by George on 2018/02/07.
//  Copyright © 2018 George Kapoya. All rights reserved.
//

import Foundation
import Alamofire



class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    class func startMonitoringNetwork() {
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        net?.listener = { status in
            if net?.isReachable ?? false {
                
                switch status {
                    
                case .reachable(.ethernetOrWiFi):
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NETWORKAVAILBLE),object: nil)
                    print("The network is reachable over the WiFi connection")
                    
                case .reachable(.wwan):
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:  NETWORKAVAILBLE),object: nil)
                    print("The network is reachable over the WWAN connection")
                    
                case .notReachable:
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NETWORKNOTREACHABLE ),object: nil)
                    print("The network is not reachable")
                    
                case .unknown :
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:  NETWORKAVAILBLE),object: nil)
                    print("It is unknown whether the network is reachable")
                    
                }
            }
            
        }
    }
}

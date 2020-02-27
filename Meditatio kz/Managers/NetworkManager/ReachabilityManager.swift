//
//  NetworkReachabilityStatusManager.swift
//  Hiromant
//
//  Created by I on 4/18/19.
//  Copyright © 2019 Nursultan. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityManager : NSObject {

    static  let shared = ReachabilityManager()

    let reachability = Reachability()!

    var isNetworkAvailable : Bool {
        return reachabilityStatus != .none
    }

    var reachabilityStatus: Reachability.Connection = .none

    @objc func reachabilityChanged(notification: Notification) {

        let reachability = notification.object as! Reachability

        reachabilityStatus = reachability.connection

        guard (UIApplication.shared.keyWindow?.rootViewController) != nil else {
            return
        }

        switch reachabilityStatus {
        case .none:
//            rootController.showNoneInternetConnectionAlert(dismissComplition: nil)
            break
        case .wifi:
//            rootController.showWifiInternetConnectionAlert()
            print("WIFI")
        case .cellular:
            print("MOBILE")
//            rootController.showCellularInternetConnectionAlert()
        }
    }

    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
}

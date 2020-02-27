//
//  +UIApplication.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 05/11/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> TabBarViewController? {
        //UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        
        return shared.keyWindow?.rootViewController as? TabBarViewController
    }
}

//
//  TabBar.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 10/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

extension UITabBarItem {
    func setImageOnly(){
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.clear], for: .selected)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.clear], for: .normal)
    }
}

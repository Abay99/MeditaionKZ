//
//  UIColor+Pallette.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 10/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//


import UIKit

extension UIColor {
    static let mainBlue = UIColor(hex: "#4548AA")
    static let mainPurple = #colorLiteral(red: 0.5138087273, green: 0.3832850158, blue: 0.958853662, alpha: 1)
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) { cString.removeFirst() }
        
        if ((cString.count) != 6) {
            self.init(hex: "ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

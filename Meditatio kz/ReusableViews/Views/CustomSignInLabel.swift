//
//  CustomSignInLabel.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/10/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

class CustomSignInLabel: UILabel {
    
    init(title: String, size: CGFloat, fontType: String, color: UIColor?) {
        super.init(frame: CGRect.zero)
        text = title
        textColor = color
        textAlignment = .left
        UIFont.fontNames(forFamilyName: "Open Sans")
        font = self.chooseFont(fontType: fontType, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func chooseFont(fontType: String, size: CGFloat) -> UIFont {
        switch fontType {
        case "bold":
            return UIFont.boldSystemFont(ofSize: size)
        case "italic":
            return  UIFont.italicSystemFont(ofSize: size)
        case "thin":
            return UIFont.systemFont(ofSize: size)
        default:
            return UIFont.systemFont(ofSize: size)
        }
    }
}

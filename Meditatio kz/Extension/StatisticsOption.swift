//
//  StatisticsOption.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 25/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

enum StatisticsOption: Int, CustomStringConvertible {
    
    case Жалпы
    case Айлық
    case Жылдық
    
    var description: String {
        switch self {
        case .Жалпы:
            return "Жалпы"
        case .Айлық:
            return "Айлық"
        case .Жылдық:
            return "Жылдық"
        }
    }
}

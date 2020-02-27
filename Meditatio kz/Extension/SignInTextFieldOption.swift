//
//  SignInTextFieldOption.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/9/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

enum SignInTextFieldOption: Int, CustomStringConvertible {
    
    case emailTextField
    case passwordTextField
    case nameTextField
    
    var description: String {
        switch self {
        case .emailTextField: return "Пошта"
        case .passwordTextField: return "Құпия сөз"
        case .nameTextField: return "Аты"
        }
    }
    
    var innerImage: UIImage {
        switch self {
        case .emailTextField: return #imageLiteral(resourceName: "emailIcon")
        case .passwordTextField: return #imageLiteral(resourceName: "nameIcon")
        case .nameTextField: return #imageLiteral(resourceName: "passwordIcon")
        }
    }
    
    var keyboard: UIKeyboardType {
        switch self {
        case .emailTextField:
            return .emailAddress
        case .passwordTextField:
            return .default
        case .nameTextField:
            return .alphabet
        }
    }
    
}

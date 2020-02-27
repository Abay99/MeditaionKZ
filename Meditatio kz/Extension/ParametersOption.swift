//
//  ParametersOption.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 25/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

enum ParametersOption: Int, CustomStringConvertible {
    
    case changeProfile
    case changePassword
    case meditationNotify
    case shareWithFriends
    case signOut
    
    var description: String {
        switch self {
        case .changeProfile:
            return "Профильді өзгерту"
        case .changePassword:
            return "Құпия сөзді өзгерту"
        case .meditationNotify:
            return "Медитация туралы еске салу"
        case .shareWithFriends:
            return "Достарыңызбен бөлісіңіз"
        case .signOut:
            return "Шығу"
        }
    }
    
    var cursorPhoto: UIImage {
        switch self {
        case .meditationNotify:
            return #imageLiteral(resourceName: "cursorIcon")
        case .changePassword:
            return #imageLiteral(resourceName: "cursorIcon")
        case .changeProfile:
            return #imageLiteral(resourceName: "cursorIcon")
        case .shareWithFriends:
            return #imageLiteral(resourceName: "cursorIcon")
        case .signOut:
            return #imageLiteral(resourceName: "signOutIcon")
        }
    }
    
    var viewControllers: UIViewController {
        switch self {
        case .meditationNotify:
            return EditProfileViewController(networkManager: NetworkManager())
        case .changePassword:
            return ChangePasswordViewController(networkManager: NetworkManager())
        case .changeProfile:
            return EditProfileViewController(networkManager: NetworkManager())
        case .shareWithFriends:
            return EditProfileViewController(networkManager: NetworkManager())
        case .signOut:
            return SignInViewController(networkManager: NetworkManager())
        }
    }
}

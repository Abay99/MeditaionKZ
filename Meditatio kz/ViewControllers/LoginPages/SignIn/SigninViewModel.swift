//
//  RegistrationViewModel.swift
//  Maltabu
//
//  Created by Nazhmeddin Babakhanov on 02/09/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

class SigninViewModel {
    
    var email: String?
    var password: String?
    
    func checkFormValidity() -> Bool {
        let isFormValid = email?.isEmpty == false && password?.isEmpty == false
        return isFormValid
    }
    
}

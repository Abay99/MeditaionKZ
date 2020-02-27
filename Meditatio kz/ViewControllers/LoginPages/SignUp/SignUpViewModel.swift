//
//  SignUpViewModel.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 25/11/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewModel {
    var name: String?
    var email: String?
    var password: String?
    
    func checkFormValidity() -> Bool {
        let isFormValid = name?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        return isFormValid
    }
}

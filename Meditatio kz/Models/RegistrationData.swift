//
//  RegistrationData.swift.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 25/11/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

struct RegistrationData: Decodable {
    let email: String?
    let firstName: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "first_name"
    }
}

//
//  ShowTrack.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 11/13/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

struct ShowTrack: Decodable {
    let id: Int?
    let name: String?
    let url: String?
    let available: Bool?
    let createdDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case available
        case createdDate = "created_date"
    }
}

//
//  ProgramsData.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/14/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation

struct ProgramsData: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Program]?
}

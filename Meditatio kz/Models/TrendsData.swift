//
//  TrendsData.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 07/11/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation

struct TrendsData: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Trend]?
}

struct Trend: Decodable {
    let name: String
}

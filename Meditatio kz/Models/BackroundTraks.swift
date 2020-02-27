//
//  BackroundTraks.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 14/11/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation

struct BackroundTraks: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [BTrack]?
}

struct BTrack: Decodable {
    let id: Int
    let name: String
    let photo: String
    let url: String
    let available: Bool
    let created_date: String
}

//
//  Traks.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 08/11/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation

struct TrackData: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Track]?
}


struct PlaylistDetail: Decodable{
    let id: Int
    let name: String
    let img: String
    let progress: Int
    let available: Bool
    let description: String?
    let tracks: [Track]?
    let created_date: String
}

struct Track: Decodable {
    let id: Int
    let name: String
    let url: String
    let available: Bool
    let finished: Bool?
    var liked: Bool?
    let duration: Int?
    let created_date: String
    var fileUrl: String?
}

//
//  Music.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 06/11/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation

struct MusicPlaylist: Decodable {
    let id: Int
    let name: String
    let img: String
    let progress: Int
    let available: Bool
    let description: String
    var liked: Bool
    let created_date: String
}

//
//  MusicPlaylists.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 06/11/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation

struct MusicPlaylists: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [MusicPlaylist]?
}

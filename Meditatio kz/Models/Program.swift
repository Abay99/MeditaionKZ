//
//  Program.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 07/11/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation

struct Program: Decodable {
    let id: Int
    let name: String?
    let playlists: [MusicPlaylist]?
}


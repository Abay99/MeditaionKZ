//
//  NumericalData.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 11/14/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

struct NumericalData: Decodable {
    let trackNumber: Int?
    let meditationTime: Int?
    let playlistNumber: Int?
    
    enum CodingKeys: String, CodingKey {
        case trackNumber = "finished_tracks"
        case meditationTime = "meditated_time"
        case playlistNumber = "finished_playlists"
    }
}

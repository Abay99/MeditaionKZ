//
//  PaymentType.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 02/12/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
// PaymentType

import Foundation

struct PaymentType: Decodable {
    let count: Int
    let next: Int?
    let previous: Int?
    let results: [Payment]?
}

struct Payment: Decodable {
    let id: Int
    let name: String?
    let price: Int
    let period: Int
}

//
//  TimeGraphData.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/22/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation

struct TimeGraphData {
    var order: Int
    var amount: String
    var month: String
    var percentage: Double{
        didSet{
            amount = "\(Int(percentage))"
        }
    }
    
    init (order: Int, amount: String, month: String, percentage: Double) {
        self.order = order
        self.amount = amount
        self.month = month
        self.percentage = percentage
    }
}

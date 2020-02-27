//
//  RunningTimeRepository.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/22/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation

class RunningTimeRepository {
    
    static let instance = RunningTimeRepository()
    
    var timeGraphCollection: [TimeGraphData]?
    
    func retrieveTimeGraphCollection (completion: @escaping ([TimeGraphData]?) -> ()) {
        
        if timeGraphCollection != nil {
            completion(timeGraphCollection)
        } else {
            timeGraphCollection = self.createTimeCollection()
            completion(timeGraphCollection)
        }
    }
    
    private func createTimeCollection () -> [TimeGraphData] {
        
        let monday = TimeGraphData.init(order: 0, amount: "0", month: "ДС", percentage: 0)
        let tuesday = TimeGraphData.init(order: 1, amount: "0", month: "СС", percentage: 0)
        let wednesday = TimeGraphData.init(order: 2, amount: "0", month: "СР", percentage: 0)
        let thursday = TimeGraphData.init(order: 3, amount: "0", month: "БС", percentage: 0)
        let friday = TimeGraphData.init(order: 4, amount: "0", month: "ЖМ", percentage: 0)
        let saturday = TimeGraphData.init(order: 5, amount: "0", month: "СБ", percentage: 0)
        let sunday = TimeGraphData.init(order: 6, amount: "0", month: "ЖС", percentage: 0)
        
        return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
    }
}

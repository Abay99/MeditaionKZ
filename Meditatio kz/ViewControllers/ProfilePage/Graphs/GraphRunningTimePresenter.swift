//
//  GraphRunningTimePresenter.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/22/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation

class GraphRunningTimePresenter {
    
    var graphRunningTimeView: GraphRunningTimeView?
    var runningTimeRepository: RunningTimeRepository?
    
    init(runningTimeRepository: RunningTimeRepository) {
        self.runningTimeRepository = runningTimeRepository
    }
    
    func attachView (view: GraphRunningTimeView) {
        graphRunningTimeView = view
    }
    
    func detachView () {
        graphRunningTimeView = nil
    }
    
    func viewDidLoad() {
        self.updateInterface()
    }
    
    func viewDidAppear() {
    }
    
    func viewWillAppear() {
    }
    
    func viewDidDisappear() {
    }
    
    func updateInterface () {
        runningTimeRepository?.retrieveTimeGraphCollection(completion: { (runningGraphDataCollection) in
            if runningGraphDataCollection != nil {
                self.graphRunningTimeView?.updateInfo(runningTimeCollection: runningGraphDataCollection!)
            }
            
        })
    }
}

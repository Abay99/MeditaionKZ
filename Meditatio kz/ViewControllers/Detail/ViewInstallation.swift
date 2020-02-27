//
//  ViewInstallation.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 21/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//


protocol ViewInstallation {
    func setupViews()
    func addSubviews()
    func setViewConstraints()
    func stylizeViews()
    func doSomethingExtra()
}

extension ViewInstallation {
    func setupViews() {
        addSubviews()
        setViewConstraints()
        stylizeViews()
        doSomethingExtra()
    }
    
    func doSomethingExtra() {}
}

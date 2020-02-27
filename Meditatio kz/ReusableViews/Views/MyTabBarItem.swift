//
//  MyTabBarItem.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 28/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

final class MyTabBarItem: UITabBarItem {
    
    override var title: String? {
        get { return nil }
        set { super.title = newValue }
    }
    
    override var imageInsets: UIEdgeInsets {
        get { return UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0) }
        set { super.imageInsets = newValue }
    }
    
    convenience init(image: UIImage? , selectedImage: UIImage?) {
        self.init()
        
        self.image = image
        self.selectedImage = image
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

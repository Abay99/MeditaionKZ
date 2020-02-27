//
//  TabBarViewController.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 09/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        makeTab()
        
        
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = .mainPurple
        self.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.tabBar.isTranslucent = true
        self.tabBar.layer.masksToBounds = true
        self.tabBar.layer.cornerRadius = 10
        
        
        

        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.selectedIndex = 0
    }
    
    
    func makeTab(){
        // Niews view controller
        self.viewControllers = tap()
        
    }
    
    func tap() -> [UINavigationController] {
        // Music view controller
        let homeViewController = MainViewController(networkManager: networkManager)
        homeViewController.tabBarItem = MyTabBarItem.init(image: #imageLiteral(resourceName: "Home") , selectedImage: #imageLiteral(resourceName: "Home"))
        
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        
        // main view controller
        let programsViewController = ProgamsViewController(networkManager: networkManager)
        programsViewController.tabBarItem = MyTabBarItem.init(image: #imageLiteral(resourceName: "book") , selectedImage: #imageLiteral(resourceName: "book"))
        
        let programsNavController = UINavigationController(rootViewController: programsViewController)
        
        // Concerts view controller
        let favoriteViewController = FavouriteViewController(networkManager: networkManager)
        favoriteViewController.tabBarItem = MyTabBarItem.init(image: #imageLiteral(resourceName: "star") , selectedImage: #imageLiteral(resourceName: "star"))
    
        let favoriteNavController = UINavigationController(rootViewController: favoriteViewController)
        
        // Profile view controller
        let profileViewController = ProfileViewController(networkManager: networkManager)
        profileViewController.tabBarItem = MyTabBarItem.init(image: #imageLiteral(resourceName: "profile") , selectedImage:#imageLiteral(resourceName: "profile"))
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        
        
        // Tab bar controllers
        let controllers = [homeNavController, programsNavController, favoriteNavController, profileNavController ]
        
        return controllers
    }
    
   
}

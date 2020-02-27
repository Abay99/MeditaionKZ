//
//  NavigationController.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 21/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    //    MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        interactivePopGestureRecognizer?.delegate = self
        
        /// Setting design
        navigationBar.setupNavigationAppearance()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
    }
    
    /// Setting back button to controller automatically if is not first controller in stack
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController != self.viewControllers.first {
            let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "navigationBack"), style: .plain, target: self, action: #selector(popViewController(animated:)) )
            viewController.navigationItem.leftBarButtonItem = backButton
            /// Hiding tabbar when pushed new controller
            //            viewController.tabBarController?.tabBar.isHidden = true
        } else {
            //            viewController.tabBarController?.tabBar.isHidden = false
        }
    }
    
    /// Setting gesture to swiping back
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension UINavigationBar {
    
    func setupNavigationAppearance() {
        backgroundColor = .clear
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        prefersLargeTitles = false
        tintColor = .white
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
}

//
//  ExtensionUIView.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 10/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

extension UIView{
    
    public static var name: String { return String(describing: self) }
    
    func addSubViews(views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    public var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }
    
}

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func presentInFullScreen(_ viewController: UIViewController,
                             animated: Bool,
                             completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: animated, completion: completion)
    }
}




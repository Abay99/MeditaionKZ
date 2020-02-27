//
//  CustomSignInTextField.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/9/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

class CustomSignInTextField: UITextField {
    
    let padding: CGFloat
    let height: CGFloat
    
    init(padding: CGFloat, height: CGFloat, option: SignInTextFieldOption) {
        self.padding = padding
        self.height = height
        super.init(frame: .zero)
        keyboardType = option.keyboard
        layer.cornerRadius = 10
        textAlignment = .left
        backgroundColor = .white
        layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        layer.borderWidth = 0.5
        textColor = .mainPurple
        font = UIFont.systemFont(ofSize: 12.0)
        placeholder = option.description
        tintColor = .mainPurple
        setIcon(option.innerImage)
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

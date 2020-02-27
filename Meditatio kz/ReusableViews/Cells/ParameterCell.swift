//
//  ParameterCell.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/16/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

protocol NotificationSwitch {
    func valueChange(_ value: Bool)
}

class ParameterCell: UITableViewCell {
    
    var delegateValue: NotificationSwitch?
    
    lazy var mainLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Стрессті жеңілдету", size: ConstraintConstants.w16, fontType: "default", color: .mainPurple)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    
    lazy var cursorView: UIImageView = {
        let cursorView = UIImageView()
        cursorView.image = #imageLiteral(resourceName: "cursorIcon")
        cursorView.contentMode = .scaleAspectFill
        return cursorView
    }()
    
    lazy var switchOnOff: UISwitch = {
        let switchOnOff = UISwitch()
        switchOnOff.setOn(false, animated: true)
        switchOnOff.addTarget(self, action: #selector(switchOnOffPressed), for: .valueChanged)
        switchOnOff.isHidden = true
        return switchOnOff
    }()
    
    @objc
    func switchOnOffPressed() {
        delegateValue?.valueChange(switchOnOff.isOn)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //common func to init our view
    func setupViews() {
        self.selectionStyle = .none
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        contentView.addSubViews(views: [mainLabel, cursorView, switchOnOff])
    }
    
    func setupLayout() {
        mainLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(ConstraintConstants.h50)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(ConstraintConstants.h15)
        }
        
        cursorView.snp.makeConstraints { make in
            make.width.height.equalTo(ConstraintConstants.w16)
            make.right.equalToSuperview().offset(-ConstraintConstants.h15)
            make.centerY.equalToSuperview()
        }
        
        switchOnOff.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-ConstraintConstants.h15)
            make.centerY.equalTo(mainLabel.snp.centerY)
        }
    }
}

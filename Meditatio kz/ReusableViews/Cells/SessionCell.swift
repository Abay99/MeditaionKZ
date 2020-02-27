//
//  SessionTableViewCell.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/14/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

class SessionCell: UITableViewCell {
    
    var data: Track? {
        didSet {
            if let one = data{
                sessionLabel.text = one.name
            }
//            sessionLabel.text = data.id"
//            programLabel.text = data.programTitle
        }
    }
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "playIcon")
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var downloadButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "downloadIcon")
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(downloadButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func playButtonPressed() {
        
    }
    
    @objc func downloadButtonPressed() {
        
    }
    
    lazy var sessionLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Тынысыңызды байқаныз", size: 16.0, fontType: "thin", color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        return label
    }()
    
    lazy var programLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Стрессті жеңілдету", size: 10.0, fontType: "bold", color: .mainPurple)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sessionLabel, programLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupViews()
        setupLayout()
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    
    func setupViews() {
        contentView.addSubViews(views: [playButton, downloadButton, stackView])
    }
    
    func setupLayout() {
        playButton.snp.makeConstraints { (make) in
            make.left.equalTo(ConstraintConstants.s16)
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        downloadButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-ConstraintConstants.s16)
            make.height.width.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(playButton.snp.right).offset(ConstraintConstants.h20)
            make.width.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//
//  StartNowCollectionViewCell.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 30/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class StartNowCollectionViewCell: UICollectionViewCell {
    
    var data: MusicPlaylist? {
        didSet {
            if let data = data{
                let url = data.img
                let resource = ImageResource(downloadURL: URL(string: url)!, cacheKey: url)
                mainImageView.kf.setImage(with: resource)
                programLabel.text = data.name
                sessionLabel.text = data.description
                var image = UIImage()
                if data.available == false{
                    image = #imageLiteral(resourceName: "lockedButton")
                }else if data.liked == true{
                    image = #imageLiteral(resourceName: "LikedButton")
                }
                
                likeButton.setBackgroundImage(image, for: .normal)
                programSlider.setValue(Float(data.progress), animated: false)
            }
        }
    }
    
    lazy var mainImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "programImage")
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.layer.cornerRadius = 10
        return image
    }()
    
    lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 10
        
        mainView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mainView.layer.shadowColor = UIColor.mainPurple.withAlphaComponent(0.1).cgColor
        mainView.layer.shadowOffset = CGSize(width: 3, height: 3)
        mainView.layer.shadowOpacity = 1.0
        mainView.layer.shadowRadius = 4.0
        mainView.layer.masksToBounds = false
        
        return mainView
    }()
    
    lazy var programLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Стрессті жеңілдету", size: ConstraintConstants.w15, fontType: "bold", color: .mainPurple)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.minimumScaleFactor = 0.2
        return label
    }()
    
    lazy var sessionLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "50% аяқталды", size: ConstraintConstants.w13, fontType: "default", color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        return label
    }()
    
    lazy var programSlider: CustomSlider  = {
        let slider = CustomSlider()
        
        slider.isUserInteractionEnabled = false
        slider.trackWidth = contentView.bounds.height * 0.02
        slider.minimumTrackTintColor = .mainPurple
        slider.maximumTrackTintColor = UIColor.lightGray.withAlphaComponent(0.1)
    
        slider.minimumValue = 0.0
        slider.maximumValue = 100.0
        slider.layer.cornerRadius = contentView.bounds.height * 0.02
        slider.layer.masksToBounds = true
        slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider.thumbTintColor = .clear
        slider.setThumbImage(UIImage(), for: .normal)
        return slider
    }()
    
    @objc
    func valueChanged() {
        
    }
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(lockedButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    
    @objc
    func lockedButtonPressed() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        mainImageView.addSubViews(views: [likeButton])
        mainView.addSubViews(views: [programSlider, programLabel, sessionLabel])
        contentView.addSubViews(views: [mainImageView, mainView])
    }
    
    
    func setupLayout(){
        
        mainImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(ConstraintConstants.h8)
            make.height.equalTo(contentView.bounds.height * 0.75)
        }
        
        mainView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(mainImageView).multipliedBy(0.8)
            make.height.equalTo(mainImageView).multipliedBy(0.3)
            make.top.equalTo(mainImageView.snp.bottom).offset(-contentView.bounds.height * 0.12)
            
        }
        
        likeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h10)
            make.right.equalToSuperview().offset(-ConstraintConstants.h10)
            make.width.height.equalTo(contentView.bounds.width * 0.15)
        }
        
        programLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ConstraintConstants.s16)
            make.right.equalTo(-ConstraintConstants.s16)
            make.top.equalTo(ConstraintConstants.s8)
            make.height.equalTo(ConstraintConstants.h30)
        }
        
        sessionLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(programLabel)
            make.height.equalTo(ConstraintConstants.h20)
            make.top.equalTo(programLabel.snp.bottom)
        }
        
        programSlider.snp.makeConstraints { (make) in
            make.top.equalTo(sessionLabel.snp.bottom)
            make.left.equalToSuperview().offset(ConstraintConstants.h10)
            make.right.equalToSuperview().offset(-ConstraintConstants.h10)
        }
        
        
        
    }
}

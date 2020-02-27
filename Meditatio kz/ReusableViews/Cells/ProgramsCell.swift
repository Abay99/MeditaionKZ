//
//  ProgramsCell.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/14/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit
import Kingfisher

class v: UICollectionViewCell {
    
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
                
                lockedButton.setBackgroundImage(image, for: .normal)
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
    
    lazy var programLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Стрессті жеңілдету", size: ConstraintConstants.w15, fontType: "bold", color: .mainPurple)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()
    
    lazy var sessionLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Күйзеліспен күресейік", size: ConstraintConstants.w13, fontType: "default", color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        return label
    }()
    
    lazy var programSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.trackWidth = contentView.bounds.height * 0.03
        slider.minimumTrackTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        slider.maximumTrackTintColor = UIColor.lightGray
//        slider.thumbTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        slider.minimumValue = 0
        slider.maximumValue = 100
//        slider.isContinuous = true
        slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider.thumbTintColor = .clear
        slider.layer.cornerRadius = contentView.bounds.height * 0.03
        slider.layer.masksToBounds = true
        slider.setThumbImage(UIImage(), for: .normal)
        return slider
    }()
    
    lazy var lockedButton: UIButton = {
        let button = UIButton()
        let image = #imageLiteral(resourceName: "lockedButton")
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(lockedButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc
    func valueChanged() {
        
    }
    
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
        mainImageView.addSubViews(views: [programSlider, lockedButton])
        contentView.addSubViews(views: [mainImageView, programLabel, sessionLabel])
    }

    
    func setupLayout(){
        
        mainImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(contentView.bounds.height * 0.8)
        }
        
        programSlider.snp.makeConstraints { (make) in
            make.bottom.equalTo(-ConstraintConstants.h10)
            make.left.equalToSuperview().offset(ConstraintConstants.h10)
            make.right.equalToSuperview().offset(-ConstraintConstants.h10)
        }
        
        lockedButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h5)
            make.right.equalToSuperview().offset(-ConstraintConstants.h5)
            make.width.height.equalTo(contentView.bounds.width * 0.2)
        }

        programLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(mainImageView.snp.bottom)
        }

        sessionLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(programLabel.snp.bottom)
        }
    }
}

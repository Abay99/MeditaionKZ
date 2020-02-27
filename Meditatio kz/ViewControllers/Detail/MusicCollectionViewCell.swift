//
//  MusicCollectionViewCell.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 21/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class MusicCollectionViewCell: UICollectionViewCell {
    
    var oneTrack: Track? {
        didSet {
            if let oneTrack = oneTrack{
                titLabel.text = oneTrack.name
            }
        }
    }
        
//            cityLabel.text = oneHot.cityID.name
//            numberOfPhotoLabel.text = "\(oneHot.img.web!.count)"
//            if oneHot.price.kind == "value"{
//                titLabel.text = "\(oneHot.price.value!) ₸"
//            }else{
//                titLabel.text = KindOfPriceOption(rawValue: oneHot.price.kind)?.description.localized(bool: (UserDefaults.standard.string(forKey: "lang") == nil))
//            }
//            if oneHot.img.web!.count > 0{
//                let url = oneHot.img.web![0].small
//                let resource = ImageResource(downloadURL: URL(string: url)!, cacheKey: url)
//                image.kf.setImage(with: resource)
//            }else{
//                image.image = #imageLiteral(resourceName: "list-empty-photo")
//            }


//    }
    
    lazy var playImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Play")
        image.contentMode = UIView.ContentMode.scaleAspectFill
        return image
    }()
    
    lazy var titLabel: UILabel = {
        let label = UILabel()
        label.text = "Тынысыңызды байқаңыз"
        label.textColor = .mainBlue
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var durationMusicLabel: UILabel = {
        let label = UILabel()
        label.text = "5 мин."
        label.textColor = .mainPurple
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 2
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubviews()
    }
    
    private func addSubviews(){
      
        self.addSubViews(views: [playImage, titLabel, durationMusicLabel])
        
        playImage.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.left.centerY.equalToSuperview()
        }
        
        titLabel.snp.makeConstraints { make in
            make.left.equalTo(playImage.snp.right).offset(ConstraintConstants.s16)
            make.right.equalTo(durationMusicLabel.snp.left).offset(-16)
            make.height.equalToSuperview().multipliedBy(0.9)
            make.centerY.equalTo(playImage)
        }
        
        durationMusicLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(playImage)
        }
        
    }
    
//    private func addShadow(){
//        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
//        layer.shadowOffset = CGSize(width: -1, height: 3)
//        layer.shadowOpacity = 1.0
//        layer.shadowRadius = 5.0
//        layer.cornerRadius = 8
//        layer.masksToBounds = false
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}

//
//  OneCollectionViewCell.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 24/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit
import Kingfisher

class OneCollectionViewCell: UICollectionViewCell {
    
    var oneHot: BTrack! {
        didSet {
            nameLabel.text = oneHot.name
        
            let url = oneHot.photo
            print(url)
            let resource = ImageResource(downloadURL: URL(string: url)!, cacheKey: url)
            image.kf.setImage(with: resource)
        }
    }
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "photoDetail")
        image.layer.borderWidth = 0.2
        image.layer.masksToBounds = true
        image.contentMode = UIView.ContentMode.scaleToFill
        image.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        image.layer.shadowOffset = CGSize(width: -1, height: 3)
        image.layer.shadowOpacity = 1.0
        image.layer.shadowRadius = 5.0
        image.layer.cornerRadius = 8
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Толқындардың шуылы"
        label.textColor = .mainBlue
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews(){
        self.addSubViews(views: [image, nameLabel])
        
        image.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalTo(4)
            make.right.equalTo(-4)
            make.height.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(image)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.top.equalTo(image.snp.bottom).offset(4)
        }
        
        
        
    }
    
}

//
//  File.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 10/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    
    lazy var imageOneItem: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "1")
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.contentMode = UIView.ContentMode.scaleAspectFill
        return image
    }()
    
    
    lazy var rightTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Жаңа"
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 10
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.textColor = .white
        lbl.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0.3)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupConstraints(){
    
        self.addSubViews(views: [imageOneItem, rightTitleLabel])
        
        imageOneItem.snp.makeConstraints { (make) in
            make.right.bottom.top.left.equalToSuperview()
        }
        
        rightTitleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(imageOneItem).offset(16)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
    }
}

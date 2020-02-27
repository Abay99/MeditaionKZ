//
//  DetailHeaderView.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 21/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

protocol PlayMusicDelegate {
    func playMusic()
}

class HeaderView: UICollectionReusableView {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "photoDetail"))
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()

    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lbl.font = UIFont.systemFont(ofSize: 34)
        lbl.text = ""
        return lbl
    }()
    
    lazy var detailLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.text = ""
        return lbl
    }()
    
    lazy var playerImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "playerButton"))
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = ConstraintConstants.s48
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playMusic))
        tapGesture.numberOfTapsRequired = 1
        iv.addGestureRecognizer(tapGesture)
        return iv
    }()
    
    @objc func playMusic() -> Void {
        delegate?.playMusic()
    }
    
    lazy var howManyMusicLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .mainBlue
        lbl.font = UIFont.systemFont(ofSize: 24)
        return lbl
    }()
    
    var delegate: PlayMusicDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // custom code for layout
        addSubViews(views: [imageView, view, titleLabel, detailLabel, playerImageView, howManyMusicLabel])
   
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-10)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.80)
        }
        
        view.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(imageView)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageView.snp.centerY)
            make.left.equalTo(ConstraintConstants.s16)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(ConstraintConstants.s16)
            make.right.equalTo(-ConstraintConstants.s16)
            make.height.equalTo(ConstraintConstants.height * 0.15)
        }
        
        playerImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(ConstraintConstants.s96)
            make.bottom.equalTo(imageView).offset(ConstraintConstants.s48)
            make.centerX.equalTo(imageView.snp.centerX)
        }
        
        howManyMusicLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ConstraintConstants.s16)
            make.bottom.equalToSuperview().offset(-ConstraintConstants.height*0.03)
        }
        
        //blur
        setupVisualEffectBlur()
    }
    
    var animator: UIViewPropertyAnimator!
    
    fileprivate func setupVisualEffectBlur() {
        animator = UIViewPropertyAnimator(duration: 3.0, curve: .linear, animations: { [weak self] in
            
            // treat this area as the end state of your animation
            let blurEffect = UIBlurEffect(style: .regular)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            
            self?.imageView.addSubview(visualEffectView)
            
            visualEffectView.snp.makeConstraints { (make) in
                make.top.bottom.left.right.equalToSuperview()
            }
        })

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  SearchCell.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/24/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

class RecommendedCell: UICollectionViewCell {
    
//    var data: ProgramsData? {
//        didSet {
//            guard let data = data else { return }
//            programLabel.text = data.programTitle
//        }
//    }
    
    lazy var programLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Стрессті жеңілдету", size: ConstraintConstants.w18, fontType: "thin", color: .mainPurple)
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        contentView.addSubview(programLabel)
    }
    
    func setupLayout() {
        programLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(ConstraintConstants.w30)
            make.right.equalToSuperview().offset(-ConstraintConstants.w30)
            make.top.equalToSuperview().offset(ConstraintConstants.h5)
            make.bottom.equalToSuperview().offset(-ConstraintConstants.h5)
            make.height.equalTo(ConstraintConstants.h20)
        }
    }
}

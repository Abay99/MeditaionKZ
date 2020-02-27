//
//  ProgramAdvantage.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 11/20/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

class ProgramAdvantage: UIView {
    
    //MARK: - UIElements
    
    lazy var startImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "Background")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var rowTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Барлық материалдарға шектеусіз қол жеткізе отырып, тынығып, ұйықтаңыз."
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - Initializers
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        self.rowTitleLabel.text = title
        backgroundColor = .clear
        setupViews()
        setupLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private setup methods
    
    private func setupViews() {
        addSubViews(views: [startImageView, rowTitleLabel])
    }
    
    private func setupLayouts() {
        startImageView.snp.makeConstraints {
            $0.left.equalTo(ConstraintConstants.w13)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(ConstraintConstants.h20)
        }
        
        rowTitleLabel.snp.makeConstraints {
            $0.left.equalTo(startImageView.snp.right).offset(ConstraintConstants.w13)
            $0.right.equalTo(-ConstraintConstants.w30)
            $0.height.equalTo(ConstraintConstants.h40)
            $0.centerY.equalTo(startImageView.snp.centerY)
        }
    }
}

//
//  MonthPaymentView.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 11/20/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

class MonthPaymentView: UIView {
    
    lazy var quantityOfMonthTitle: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "1", size: 26.0, fontType: "bold", color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        label.textAlignment = .center
        return label
    }()
    
    lazy var monthLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "", size: 14.0, fontType: "default", color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        label.textAlignment = .center
        return label
    }()
    
    lazy var paymentForMonthsLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "KZT 1,490.00/ай.", size: 10.0, fontType: "thin", color: .mainPurple)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    init(frame: CGRect, quantityOfMonth: String, paymentForOneMonth: String) {
        super.init(frame: frame)
        self.quantityOfMonthTitle.text = quantityOfMonth
        self.paymentForMonthsLabel.text = paymentForOneMonth
        setupInitialViews()
        setupViews()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInitialViews() {
        backgroundColor = .white
        clipsToBounds = true
//        layer.cornerRadius = 10
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 4.0
        layer.masksToBounds = false
    }
    
    func setupViews() {
        addSubViews(views: [quantityOfMonthTitle, monthLabel, paymentForMonthsLabel])
    }
    
    func setupLayout() {
        quantityOfMonthTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(ConstraintConstants.h30)
            $0.height.equalTo(ConstraintConstants.h20)
            $0.width.equalTo(ConstraintConstants.w30)
        }
        
        monthLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(quantityOfMonthTitle.snp.bottom).offset(ConstraintConstants.h5)
            $0.height.equalTo(ConstraintConstants.h15)
            $0.width.equalTo(ConstraintConstants.w25)
        }
        
        paymentForMonthsLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(monthLabel.snp.bottom).offset(ConstraintConstants.h5)
            $0.height.equalTo(ConstraintConstants.h30)
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
    }
}

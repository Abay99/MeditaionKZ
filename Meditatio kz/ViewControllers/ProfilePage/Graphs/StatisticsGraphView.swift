//
//  StatisticsGraphView.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/22/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit
import MBCircularProgressBar

class StatisticsGraphView: UIView {
    
    lazy var pieChartLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Ақыл-ой өлшеми", size: 14.0, fontType: "thin", color: .mainPurple)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0;
        return label
    }()
    
    lazy var barGraphLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Бір аптада", size: 14.0, fontType: "thin", color: .mainPurple)
        return label
    }()
    
    lazy var barGraphView: GraphRunningTimeViewController = {
        let view = GraphRunningTimeViewController()
        return view
    }()
    
    lazy var pieChartView: MBCircularProgressBarView = {
        let view = MBCircularProgressBarView()
        view.value = 0
        view.maxValue = 100
        view.unitFontSize = 30
        view.fontColor = .mainPurple
        view.progressColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        view.progressLineWidth = 10
        view.emptyLineColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.5)
        view.emptyLineWidth = 10
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.progressAngle = 100
        view.showUnitString = false
        view.progressStrokeColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialViews()
        setupViews()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInitialViews() {
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 4.0
        layer.masksToBounds = false
    }
    
    func setupViews() {
        addSubViews(views: [pieChartLabel, barGraphLabel, pieChartView,  barGraphView.view])
    }
    
    func setupLayout() {
        pieChartLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h10)
            make.left.equalToSuperview().offset(ConstraintConstants.w40)
            make.height.equalTo(ConstraintConstants.h35)
            make.width.equalTo(ConstraintConstants.w60)
        }
        
        barGraphLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h10)
            make.right.equalToSuperview().offset(-ConstraintConstants.w40)
            make.height.equalTo(ConstraintConstants.h20)
            make.width.equalTo(ConstraintConstants.w130)
        }
        
        pieChartView.snp.makeConstraints { (make) in
            make.top.equalTo(pieChartLabel.snp.bottom)
            make.left.equalToSuperview().offset(ConstraintConstants.w30)
            make.height.equalTo(ConstraintConstants.h80)
            make.width.equalTo(ConstraintConstants.w80)
        }
        
        barGraphView.view.snp.makeConstraints { (make) in
            make.top.equalTo(barGraphLabel.snp.bottom).offset(ConstraintConstants.h10)
            make.right.equalToSuperview().offset(-ConstraintConstants.w15)
            make.height.equalTo(ConstraintConstants.h100)
            make.width.equalTo(ConstraintConstants.w190)
        }
    }
}

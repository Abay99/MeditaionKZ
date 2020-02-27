
//
//  NumberedInformationView.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/22/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

class NumericInformationView: UIView {
    
    private let networkManager: NetworkManager
    
    lazy var sessionNumberTitle: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Сессия саны", size: 14.0, fontType: "thin", color: .mainPurple)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var meditationTimeTitle: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Медитация уақыты", size: 14.0, fontType: "thin", color: .mainPurple)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0;
        label.textAlignment = .center
        return label
    }()
    
    lazy var allCollectionsTitle: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Жинақ саны", size: 14.0, fontType: "thin", color: .mainPurple)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0;
        label.textAlignment = .center
        return label
    }()
    
    lazy var sessionNumberLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "0", size: 36.0, fontType: "default", color: .mainPurple)
        label.textAlignment = .center
        return label
    }()
    
    lazy var meditationTimeLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "5", size: 36.0, fontType: "default", color: .mainPurple)
        label.textAlignment = .center
        return label
    }()
    
    lazy var allCollectionsLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "10", size: 36.0, fontType: "default", color: .mainPurple)
        label.textAlignment = .center
        return label
    }()
    
    init(frame: CGRect, networkManager: NetworkManager) {
        self.networkManager = networkManager
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
        addSubViews(views: [sessionNumberTitle, sessionNumberLabel, meditationTimeTitle, meditationTimeLabel, allCollectionsTitle, allCollectionsLabel])
    }
    
    func setupLayout() {
        sessionNumberTitle.snp.makeConstraints {
            $0.top.equalTo(ConstraintConstants.h25)
            $0.left.equalTo(ConstraintConstants.w30)
            $0.height.equalTo(ConstraintConstants.h30)
            $0.width.equalTo(ConstraintConstants.w60)
        }
        
        meditationTimeTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h25)
            make.left.equalTo(sessionNumberTitle.snp.right).offset(ConstraintConstants.w35)
            make.height.equalTo(ConstraintConstants.h30)
            make.width.equalTo(ConstraintConstants.w80)
        }

        allCollectionsTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h25)
            make.left.equalTo(meditationTimeTitle.snp.right).offset(ConstraintConstants.w30)
            make.height.equalTo(ConstraintConstants.h30)
            make.width.equalTo(ConstraintConstants.w80)
        }

        sessionNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sessionNumberTitle.snp.bottom).offset(ConstraintConstants.h20)
            make.centerX.equalTo(sessionNumberTitle.snp.centerX)
            make.height.equalTo(ConstraintConstants.h30)
            make.width.equalTo(ConstraintConstants.w80)
        }

        meditationTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sessionNumberTitle.snp.bottom).offset(ConstraintConstants.h20)
            make.centerX.equalTo(meditationTimeTitle.snp.centerX)
            make.height.equalTo(ConstraintConstants.h30)
            make.width.equalTo(ConstraintConstants.w80)
        }

        allCollectionsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sessionNumberTitle.snp.bottom).offset(ConstraintConstants.h20)
            make.centerX.equalTo(allCollectionsTitle.snp.centerX)
            make.height.equalTo(ConstraintConstants.h30)
            make.width.equalTo(ConstraintConstants.w80)
        }
    }
    
    func fetchData(parameters: [String: String]) {
        
        guard let token = StorageManager.shared.token else {
            print("Error in ProfilePage, no user data (token)")
            return
        }
        
        networkManager.makeRequest(endpoint: Endpoints.getNumericalInformations(token: token, params: parameters)) { (result: Result<NumericalData>) in
            switch result {
            case .failure(let errorMessage):
                print(errorMessage)
            case .success(let res):
                print("Result \(result)")
                if let sessionNumber = res.trackNumber, let meditationTime = res.meditationTime,
                    let playlistNumber = res.playlistNumber {
                        self.sessionNumberLabel.text = "\(sessionNumber)"
                        self.meditationTimeLabel.text = "\(meditationTime)"
                        self.allCollectionsLabel.text = "\(playlistNumber)"
                }
            }
        }
    }
}

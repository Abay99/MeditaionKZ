//
//  FavouriteHeaderView.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 28/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit
import Alamofire
protocol ChangeViewDelegate {
    func pushMore(index: Int)
    func pushDetail(index: Int, which: Int)
}

protocol ChangeHeight {
    func changeHeight(zeroOrStatic: Bool)
}

enum TypeHeader{
    case favorite
    case search
}

class FavouriteHeaderView: UIView {
    
    var delegate:ChangeViewDelegate?
    
    var delegateHeight: ChangeHeight?
    
    var text = ""{
        didSet{
            if !text.isEmpty {
                fetchData()
            }
            
        }
    }
    
    var programs:[MusicPlaylist] = []{
        didSet{
            collectionView.reloadData()
        }
    }

    private let networkManager: NetworkManager
    private let type: TypeHeader
    
    // MARK: Initializer
    init(frame: CGRect, networkManager: NetworkManager, type: TypeHeader) {
        self.type = type
        self.networkManager = networkManager
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -UIComponents
    
    lazy var shortDescriptionLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Қысқаша сипаттамасы", size: 16.0, fontType: "thin", color:  #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        return label
    }()
    
    lazy var programsLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Бағдарламалар", size: 24.0, fontType: "bold", color: .mainPurple)
        return label
    }()
    
    lazy var moreInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle("көбірек қарау", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.light)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        button.addTarget(self, action: #selector(moreInfoButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func moreInfoButtonPressed() {
        print(12345)
        delegate!.pushMore(index: 0)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProgramsCell.self, forCellWithReuseIdentifier: ProgramsCell.name)
        collectionView.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        //        collectionView.layer.borderColor = UIColor.black.cgColor
        //        collectionView.layer.borderWidth = 1.0
        return collectionView
    }()
    
    lazy var meditationLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Медитациялар", size: 24.0, fontType: "bold", color: .mainPurple)
        return label
    }()
}

// MARK: -Inner methods

extension FavouriteHeaderView {
    
    private func setupViews() -> Void {
        self.addSubViews(views: [shortDescriptionLabel, programsLabel, moreInfoButton, collectionView, meditationLabel])
    }
    
    private func setupConstraints() -> Void {
        
        shortDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h10)
            make.left.equalToSuperview().offset(ConstraintConstants.s16)
            make.height.equalTo(ConstraintConstants.h20)
            make.width.equalTo(ConstraintConstants.w220)
        }
        
        programsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(shortDescriptionLabel.snp.bottom)
            make.left.equalToSuperview().offset(ConstraintConstants.s16)
            make.height.equalTo(ConstraintConstants.h30)
            make.width.equalTo(ConstraintConstants.w220)
            
        }
        
        moreInfoButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(programsLabel)
            make.right.equalToSuperview().offset(-ConstraintConstants.w13)
            make.height.equalTo(ConstraintConstants.h30)
            make.width.equalTo(ConstraintConstants.w130)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(shortDescriptionLabel.snp.bottom).offset(ConstraintConstants.h40)
            make.left.equalToSuperview()
            make.height.equalTo(ConstraintConstants.h150)
            make.width.equalToSuperview()
        }
        
        meditationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(ConstraintConstants.h10)
            make.left.equalTo(ConstraintConstants.s16)
            make.height.equalTo(ConstraintConstants.h30)
            make.width.equalTo(ConstraintConstants.w220)
            
        }
    }

    private func setupBackground() -> Void {
        backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let noDataLabel = UILabel()
        noDataLabel.textAlignment = .center
        noDataLabel.textColor = .mainPurple
        noDataLabel.text = "Нәтиже жоқ"
        noDataLabel.center = self.center
        collectionView.backgroundView = noDataLabel
        collectionView.backgroundView?.isHidden = true
    }
}

// Fetching Data
extension FavouriteHeaderView{
    func fetchData(){
        
        if let token = StorageManager.shared.token{
            //HeaderBannerPlayists
            let params = ["search_str": text] as Parameters
            let endpoint = type == .favorite ? Endpoints.getLikedPlaylists(token: token) : Endpoints.getSearchPlaylists(token: token, params: params)
            networkManager.makeRequest(endpoint: endpoint) { (result: Result<MusicPlaylists>) in
                switch result {
                    case .failure(let errorMessage):
                        print(errorMessage)
                    case .success(let res):
                        if let musics = res.results{
                            if let delegateH = self.delegateHeight{
                                delegateH.changeHeight(zeroOrStatic: musics.isEmpty)
                            }
                            self.programs = musics
                        }
                }
            }
        }
    }
}

extension FavouriteHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3.5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if programs.isEmpty{
            moreInfoButton.isHidden = true
            collectionView.backgroundView?.isHidden = false
        }else{
            moreInfoButton.isHidden = false
            collectionView.backgroundView?.isHidden = true
        }
        return programs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgramsCell.name, for: indexPath) as! ProgramsCell
        cell.data = self.programs[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: ConstraintConstants.s16, bottom: 0, right: ConstraintConstants.s16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pushDetail(index: 0, which: indexPath.row)
    }
}

//
//  DetailProgramViewController.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/14/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

class DetailProgramViewController: UIViewController {
    
    private var layout = UICollectionViewFlowLayout()
    
    var detailPlaylists: [MusicPlaylist] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProgramsCell.self, forCellWithReuseIdentifier: ProgramsCell.name)
        return collectionView
    }()
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupViews()
        setupLayout()
        title = "Бағдарламалар"
    }
    
    func setupViews() {
        view.addSubViews(views: [ collectionView])
    }
    
    func setupLayout() {
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(ConstraintConstants.w13)
            make.right.equalToSuperview().offset(-ConstraintConstants.w13)
            make.bottom.equalToSuperview()
        }
    }
}

extension DetailProgramViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = ConstraintConstants.w40
        let widthCell = (ConstraintConstants.width - margin)/2
        return CGSize(width: widthCell , height: ConstraintConstants.height*0.38)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailPlaylists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgramsCell.name, for: indexPath) as! ProgramsCell
        cell.data = detailPlaylists[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController(collectionViewLayout: StretchyHeaderLayout(), networkManager: networkManager)
        
        if detailPlaylists[indexPath.row].available{
            vc.data = detailPlaylists[indexPath.row]
            self.presentInFullScreen(NavigationController(rootViewController: vc), animated: false, completion: nil)
        }else{
           print(124356)
        }
    }
}

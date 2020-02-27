//
//  StartNowCollectionViewCell.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 11/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

class StartNowTableViewCell: UITableViewCell {
    //    MARK: Properties
    private var layout = UICollectionViewFlowLayout()
    var valBool = true
    var indexSelected: Int?
    var delegate: ChangeViewDelegate?

    var beginPlaylists: [MusicPlaylist] = []{
        didSet{
            collectionView.reloadData()
        }
    }

    let rowTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "Медитация"
        label.textAlignment = .left
        label.textColor = .mainBlue
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()


    lazy var seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("көбірек қарау", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.mainPurple, for: .normal)
        button.addTarget(self, action: #selector(handleSeeMore), for: .touchUpInside)
        return button
    }()

    @objc func handleSeeMore(){
        delegate?.pushMore(index: 0)
    }

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(StartNowCollectionViewCell.self, forCellWithReuseIdentifier: StartNowCollectionViewCell.name)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()


    //    MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        setupCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Adding views to super view
    private func setupViews() {
        self.addSubViews(views: [rowTitleLabel, collectionView, seeMoreButton])
        self.selectionStyle = .none
    }

    //    MARK: Constraints
    /// Setting constraints to views
    private func setupConstraints() {
        rowTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.left.equalTo(ConstraintConstants.s16)
        }

        seeMoreButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(rowTitleLabel)
            make.right.equalTo(-ConstraintConstants.s16)
        }

        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(rowTitleLabel.snp.bottom).offset(ConstraintConstants.s8)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-ConstraintConstants.s8)
        }

    }

    private func setupCollectionView() {
        layout.itemSize = CGSize(width:  ConstraintConstants.s210, height: ConstraintConstants.height * 0.54)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    //    MARK: Targets
    // Targets from buttons, gestures and other targets
}


/// UICollectionViewDataSource functions
extension StartNowTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beginPlaylists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StartNowCollectionViewCell.name, for: indexPath) as! StartNowCollectionViewCell
        cell.data = beginPlaylists[indexPath.row]
        return cell
    }

}

/// UICollectionViewDelegateFlowLayout function for calculating size for cells
extension StartNowTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pushDetail(index: indexPath.row, which: indexSelected!)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: ConstraintConstants.s16, bottom: 0, right: ConstraintConstants.s16)
    }
}

////
////  Search.swift
////  Meditatio kz
////
////  Created by Nazhmeddin Babakhanov on 08/11/2019.
////  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
////
//
//import Foundation
////
////  SearchViewController.swift
////  Meditatio kz
////
////  Created by Abai Kalikov on 10/24/19.
////  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
////
//
//
//import Foundation
//import UIKit
//import TagListView
//import Alamofire
//
//class SearchViewController: UIViewController {
//    
//    private var programArray: [MusicPlaylist] = []{
//        didSet{
//            collectionView.reloadData()
//        }
//    }
//    
//    private var searchTags: [String] = []{
//        didSet{
//            tagListView.addTags(searchTags)
////            tagListView.reloadInputViews()
//        }
//    }
//    
//    
//    
//    //MARK: - UIElements
//    
////    lazy var cancelButton: UIBarButtonItem = {
////        let button = UIBarButtonItem(image:  #imageLiteral(resourceName: "cancelIcon"), style: .plain, target: self, action: #selector(cancelButtonPressed))
////        return button
////    }()
//    
//    @objc
//    func cancelButtonPressed() {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    lazy var searchBarTextField: UITextField = {
//        let tf = UITextField()
//        tf.textAlignment = .left
//        tf.placeholder = "Іздеу..."
//        tf.textColor = .mainPurple
//        tf.font = UIFont.systemFont(ofSize: 26.0)
//        tf.tintColor = .mainPurple
//        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        return tf
//    }()
//    
//    
//    
//    
//    
//    
//    lazy var tagListView: TagListView = {
//        let taglistView =  TagListView()
//        taglistView.tagBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        taglistView.textColor = .mainPurple
//        taglistView.cornerRadius = 15
//        
//        taglistView.borderColor =  #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
//        taglistView.borderWidth = 1.0
//        taglistView.marginX = 15
//        taglistView.marginY = 10
//        taglistView.paddingX = 15
//        taglistView.paddingY = 8
//        taglistView.delegate = self
////        taglistView.addTags(searchTags)
//        return taglistView
//    }()
//    
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .white
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.isHidden = true
//        collectionView.register(ProgramsCell.self, forCellWithReuseIdentifier: ProgramsCell.name)
//        return collectionView
//    }()
//    
//    
//   
//    private var timer: Timer?
//    
//    @objc
//    func textFieldDidChange(_ textField: UITextField) {
//        if self.searchBarTextField.text == nil || self.searchBarTextField.text == "" {
//            view.endEditing(true)
//            tagListView.isHidden = false
//            collectionView.isHidden = true
//        }else{
//            searchWithText(textField.text!)
//            tagListView.isHidden = true
//            collectionView.isHidden = false
//        }
//        collectionView.reloadData()
//    }
//    
//    func searchWithText(_ text: String){
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
//            if let token = StorageManager.shared.token{
//                let params = ["search_str": text] as Parameters
//                self.networkManager.makeRequest(endpoint: Endpoints.getSearchPlaylists(token: token, params: params)) { (result: Result<MusicPlaylists>) in
//                       switch result {
//                           case .failure(let errorMessage):
//                               print(errorMessage)
//                           case .success(let res):
//                            if let musics = res.results{
//                                self.programArray = musics
//                                print(musics)
//                            }
//                    }
//                }
//            }
//        })
//    }
//    
//    private let networkManager: NetworkManager
//    
//    init(networkManager: NetworkManager) {
//        self.networkManager = networkManager
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    
//    //MARK: - Initializations
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//        setupLayout()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        fetchData()
//    }
//    
//    
//}
//
////MARK: - Setup methods
//
//extension SearchViewController {
//    func setupViews() -> Void {
////        navigationItem.rightBarButtonItem = cancelButton
//        view.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        view.addSubViews(views: [searchBarTextField, tagListView, collectionView])
//    }
//    
//    func setupLayout() -> Void {
//        searchBarTextField.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(96.5)
//            make.left.equalToSuperview().offset(ConstraintConstants.w15)
//            make.right.equalToSuperview().offset(-ConstraintConstants.w15)
//            make.height.equalTo(ConstraintConstants.h60)
//        }
//        
//        tagListView.snp.makeConstraints { (make) in
//            make.top.equalTo(searchBarTextField.snp.bottom).offset(ConstraintConstants.h30)
//            make.left.equalTo(ConstraintConstants.w15)
//            make.right.equalTo(-ConstraintConstants.w15)
//            make.bottom.equalToSuperview()
//        }
//        
//        collectionView.snp.makeConstraints { (make) in
//            make.top.equalTo(searchBarTextField.snp.bottom).offset(ConstraintConstants.h30)
//            make.left.equalTo(ConstraintConstants.w15)
//            make.right.equalTo(-ConstraintConstants.w15)
//            make.bottom.equalToSuperview()
//        }
//    }
//}
//
////MARK: - Fetching Data
//extension SearchViewController{
//    func fetchData(){
//        if let token = StorageManager.shared.token{
//            //Trands
//            networkManager.makeRequest(endpoint: Endpoints.getSearchTrends(token: token)) { (result: Result<TrendsData>) in
//                switch result {
//                    case .failure(let errorMessage):
//                        print(errorMessage)
//                    case .success(let res):
//                        if let musics = res.results{
//                            self.searchTags = musics.map({$0.name})
//                        }
//                }
//            }
//        }
//    }
//}
//
//
////MARK: - TagListViewDelegate method
//
//extension SearchViewController: TagListViewDelegate {
//    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
//        searchBarTextField.text = title
//        collectionView.isHidden = false
//        tagListView.isHidden = true
//        searchWithText(title)
//        collectionView.reloadData()
//    }
//}
//
////MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
//
//extension SearchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let margin = ConstraintConstants.w40
//        let widthCell = (ConstraintConstants.width - margin)/2
//        return CGSize(width: widthCell , height: ConstraintConstants.height*0.38)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return programArray.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgramsCell.name, for: indexPath) as? ProgramsCell
//        cell?.data = programArray[indexPath.item]
//        return cell!
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//    }
//}

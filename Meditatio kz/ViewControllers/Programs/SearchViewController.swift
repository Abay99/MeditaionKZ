//
//  SearchViewController.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/24/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//


import Foundation
import UIKit
import TagListView
import Alamofire

class SearchViewController: UIViewController {
    
    private var tracks: [Track] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    private var searchTags: [String] = []{
        didSet{
            tagListView.addTags(searchTags)
        }
    }
    
    
    
    //MARK: - UIElements
    
    @objc
    func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
   
    
    lazy var searchBarTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.placeholder = "Іздеу..."
        tf.textColor = .mainPurple
        tf.font = UIFont.systemFont(ofSize: 26.0)
        tf.tintColor = .mainPurple
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return tf
    }()
    
    
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SessionCell.self, forCellReuseIdentifier: SessionCell.name)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.backgroundView = UIImageView.init(image: #imageLiteral(resourceName: "emptyList"))
        tableView.backgroundView?.isHidden = true
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerTableView
        return tableView
    }()
    
    
    
    
    lazy var tagListView: TagListView = {
        let taglistView =  TagListView()
        taglistView.tagBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        taglistView.textColor = .mainPurple
        taglistView.cornerRadius = 15
        
        taglistView.borderColor =  #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        taglistView.borderWidth = 1.0
        taglistView.marginX = 15
        taglistView.marginY = 10
        taglistView.paddingX = 15
        taglistView.paddingY = 8
        taglistView.delegate = self
//        taglistView.addTags(searchTags)
        return taglistView
    }()

    lazy var headerTableView: FavouriteHeaderView = {
        let view = FavouriteHeaderView(frame:CGRect.init(x: ConstraintConstants.w15, y: 0, width: ConstraintConstants.width, height: ConstraintConstants.h260), networkManager: networkManager, type: TypeHeader.search)
        view.delegate = self
        view.delegateHeight = self
        view.meditationLabel.isHidden = true
        view.shortDescriptionLabel.isHidden = true
        return view
    }()
    
    
   
    private var timer: Timer?
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        if self.searchBarTextField.text == nil || self.searchBarTextField.text == "" {
            tagListView.isHidden = false
            tableView.isHidden = true
        }else{
            searchWithText(textField.text!)
            tagListView.isHidden = true
            tableView.isHidden = false
        }
        
    }
    
    func searchWithText(_ text: String){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            if let token = StorageManager.shared.token{
                self.headerTableView.text = text
                let params = ["search_str": text] as Parameters
                self.networkManager.makeRequest(endpoint: Endpoints.getSearchTracks(token: token, params: params)) { (result: Result<TrackData>) in
                       switch result {
                           case .failure(let errorMessage):
                               print(errorMessage)
                           case .success(let res):
                            if let musics = res.results{
                                self.tracks = musics
                                print(musics)
                            }
                    }
                }
            }
        })
    }
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        fetchData()
    }
    
    
}

//MARK: - Setup methods

extension SearchViewController {
    func setupViews() -> Void {
        view.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view.addSubViews(views: [searchBarTextField, tableView, tagListView])
        tableView.isHidden = true
    }
    
    func setupLayout() -> Void {
        searchBarTextField.snp.makeConstraints { (make) in
            make.left.equalTo(ConstraintConstants.s16)
            make.right.equalTo(-ConstraintConstants.s16)
            make.top.equalTo(ConstraintConstants.h60)
            make.height.equalTo(ConstraintConstants.h60)
            
        }
        
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBarTextField.snp.bottom).offset(ConstraintConstants.h10)
            make.left.bottom.right.equalToSuperview()
        }
        
        tagListView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBarTextField.snp.bottom).offset(ConstraintConstants.h10)
            make.left.equalTo(ConstraintConstants.w15)
            make.right.equalTo(-ConstraintConstants.w15)
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - Fetching Data
extension SearchViewController{
    func fetchData(){
        if let token = StorageManager.shared.token{
            //Trands
            networkManager.makeRequest(endpoint: Endpoints.getSearchTrends(token: token)) { (result: Result<TrendsData>) in
                switch result {
                    case .failure(let errorMessage):
                        print(errorMessage)
                    case .success(let res):
                        if let musics = res.results{
                            self.searchTags = musics.map({$0.name})
                        }
                }
            }
        }
    }
}

extension SearchViewController:ChangeViewDelegate {
    func pushDetail(index: Int, which: Int) {
        let vc = DetailViewController(collectionViewLayout: StretchyHeaderLayout(), networkManager: networkManager)
        if headerTableView.programs[which].available{
            vc.data = headerTableView.programs[which]
            self.presentInFullScreen(NavigationController(rootViewController: vc), animated: false, completion: nil)
        }else{
            let vc = UnlockProgramsViewController(networkManager: networkManager)
            self.presentInFullScreen(NavigationController(rootViewController: vc), animated: false, completion: nil)
            print(124356)
        }
    }
    
    func pushMore(index: Int){
        let vc = DetailProgramViewController(networkManager: networkManager)
        vc.detailPlaylists = headerTableView.programs
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: ChangeHeight{
    func changeHeight(zeroOrStatic: Bool) {
        print("zeroOrStatic \(zeroOrStatic)")
//        if zeroOrStatic{
//            tableView.tableHeaderView?.isHidden = true
//        }else{
//            tableView.tableHeaderView?.isHidden = false
//        }

//        headerTableView.backgroundColor = .red
    }
}



//MARK: - TagListViewDelegate method

extension SearchViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        searchBarTextField.text = title
        tableView.isHidden = false
        tagListView.isHidden = true
        searchWithText(title)
//        collectionView.reloadData()
    }
}

//MARK: - UITableViewDelegateFlowLayout, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConstraintConstants.h70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tracks.count == 0{
//             tableView.backgroundView?.isHidden = false
//        }
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SessionCell.name) as! SessionCell
        cell.data = tracks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlayerViewContoller(networkManager: networkManager)
        vc.maximizePlayerDetails(episode: tracks[indexPath.row], playlistEpisodes: tracks)
        presentInFullScreen(vc, animated: true, completion: nil)
    }
}


//
//  ProgamsViewController.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 10/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit
import SnapKit
import TYCyclePagerView
import Kingfisher
import Alamofire

class ProgamsViewController: UIViewController {
    
    var navbarShow = true
    var navbarHide = true
    
    private var bannerPlaylists:[MusicPlaylist] = []{
           didSet{
               pagerView.reloadData()
           }
    }
    
    private var programsPlaylists:[Program] = []{
           didSet{
               print(programsPlaylists)
               categotyTableView.reloadData()
           }
    }
       
    
    lazy var topMeditatio: UIView = {
        let view = UIView(frame: CGRect.init(x: 0, y: topbarHeight, width: ConstraintConstants.width, height: ConstraintConstants.s160))
        return view
    }()
    
    lazy var descriptionLabel:UILabel = {
        let label = UILabel()
        label.textColor = .mainPurple
        label.text = "Қысқаша сипаттамасы"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var pagerView: TYCyclePagerView = {
        let pagerView = TYCyclePagerView()
        pagerView.isInfiniteLoop = false
        pagerView.autoScrollInterval = 0
        pagerView.layer.borderWidth = 0
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: TopCollectionViewCell.name)
        pagerView.backgroundColor = .clear
        return pagerView
    }()
    
    lazy var pageControl: TYPageControl = {
        let pageControl = TYPageControl()
//        pageControl.currentPageIndicatorSize = CGSize(width: 8, height: 8)
        pageControl.pageIndicatorSize = CGSize(width: 8, height: 8)
        pageControl.currentPageIndicatorTintColor = .mainBlue
        return pageControl
    }()
    
    
    lazy var categotyTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategotyTableViewCell.self, forCellReuseIdentifier: CategotyTableViewCell.name)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
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
        tabBarItem.setImageOnly()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupNavigationBar()
        setupConstraints()
        
    }
    
    func setupNavigationBar() -> Void {
        self.title = "Бағдарламалар"
//        localized(tableName: UserDefaults.standard.string(forKey: "lang")!)
        let right = UIBarButtonItem.init(image: #imageLiteral(resourceName: "Search"), style: .plain, target: self, action: #selector(searchButton))
        self.navigationItem.rightBarButtonItem = right
        
    }

    @objc func searchButton(){
        
//        SearchViewController(
        let vc = SearchViewController(networkManager: networkManager)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        print("Search")
    }
    
    func setupConstraints(){
        view.addSubViews(views: [categotyTableView])
        topMeditatio.addSubViews(views: [descriptionLabel, pagerView, pageControl])
    
        categotyTableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ConstraintConstants.s16)
            make.top.equalToSuperview()
        }
        
        pagerView.snp.makeConstraints { (make) in
            make.left.equalTo(ConstraintConstants.s16)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(ConstraintConstants.s16)
            make.right.bottom.equalTo(-ConstraintConstants.s16)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.width.equalTo(pagerView)
            make.height.equalTo(ConstraintConstants.s10)
            make.bottom.equalToSuperview()
        }
        
        categotyTableView.tableHeaderView = topMeditatio
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
//    fileprivate func showBadgeHighlight() {
//    UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = "New"
//    }
}

// Fetching Data
extension ProgamsViewController{
    func fetchData(){
        
        if let token = StorageManager.shared.token{
            print("token \(token)")
            //BannerPlayists
            networkManager.makeRequest(endpoint: Endpoints.getBannerPlaylists(token: token)) { (result: Result<MusicPlaylists>) in
                switch result {
                    case .failure(let errorMessage):
                        print(errorMessage)
                    case .success(let res):
                        if let musics = res.results{
                            self.bannerPlaylists = musics
                        }
                }
            }
            //ProgramsPlayists
            networkManager.makeRequest(endpoint: Endpoints.getPrograms(token: token)) { (result: Result<ProgramsData>) in
                switch result {
                    case .failure(let errorMessage):
                        print(errorMessage)
                    case .success(let res):
                        if let mus = res.results{
                            print(res)
                            self.programsPlaylists = mus
                        }
                }
            }
            
        }
    }
}

extension ProgamsViewController: TYCyclePagerViewDataSource, TYCyclePagerViewDelegate {
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        let count = bannerPlaylists.count
        pageControl.numberOfPages = count
        return count
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: self.pagerView.frame.width , height:
            self.pagerView.frame.height)
        layout.itemSpacing = 30
        layout.itemHorizontalCenter = true
        layout.itemVerticalCenter = true
        return layout
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.name, for: index) as! TopCollectionViewCell
        let url = bannerPlaylists[index].img
        let resource = ImageResource(downloadURL: URL(string: url)!, cacheKey: url)
        cell.imageOneItem.kf.setImage(with: resource)
        return cell
    }
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        pageControl.currentPage = toIndex;
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didSelectedItemCell cell: UICollectionViewCell, at index: Int) {
        let vc = DetailViewController(collectionViewLayout: StretchyHeaderLayout(), networkManager: networkManager)
        vc.data = bannerPlaylists[index]
        self.presentInFullScreen(NavigationController(rootViewController: vc), animated: false, completion: nil)
    }
    
    
}


extension ProgamsViewController:ChangeViewDelegate {
    func pushDetail(index: Int, which:Int) {
        if let playlist = self.programsPlaylists[index].playlists{
            let vc = DetailViewController(collectionViewLayout: StretchyHeaderLayout(), networkManager: networkManager)
            if playlist[which].available{
                vc.data = playlist[which]
                
                self.presentInFullScreen(NavigationController(rootViewController: vc), animated: false, completion: nil)
            }else{
                let vc = UnlockProgramsViewController(networkManager: networkManager)
                self.presentInFullScreen(NavigationController(rootViewController: vc), animated: false, completion: nil)
               
                print(124356)
            }
            
        }
    }
    
    func pushMore(index: Int){
        if let playlist = self.programsPlaylists[index].playlists{
            let vc = DetailProgramViewController(networkManager: networkManager)
            vc.detailPlaylists = playlist
            navigationController?.pushViewController(vc, animated: true)
        }
       
    }
}


extension ProgamsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programsPlaylists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategotyTableViewCell.name, for: indexPath) as! CategotyTableViewCell
        cell.delegate = self
        cell.indexSelected = indexPath.row
        if let playlist = programsPlaylists[indexPath.row].playlists{
            cell.popularPlaylists = playlist
            if let name = programsPlaylists[indexPath.row].name{
                cell.rowTitleLabel.text = name
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        print(row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConstraintConstants.height * 0.4
    }
}


//extension ProgamsViewController:  UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        if scrollView.contentOffset.y > 40{
//            if navbarShow {
//                self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9688585069, green: 1, blue: 1, alpha: 1)
//                self.navigationController?.navigationBar.isTranslucent = false
//                navbarShow = false
//                navbarHide = true
//            }
//
//        }
//        else{
//            if navbarHide {
//                self.navigationController?.navigationBar.isTranslucent = true
//                navbarShow = true
//                navbarHide = false
//            }
//        }
//    }
//}

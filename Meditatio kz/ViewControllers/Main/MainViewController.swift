//
//  MainViewController.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 18/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit
import SnapKit
import TYCyclePagerView
import Kingfisher
import Alamofire

extension MainViewController {
    /// WARNING: Change these constants according to your project's design
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 0
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
        /// Image height/width for Landscape state
        static let ScaleForImageSizeForLandscape: CGFloat = 0.65
    }
}

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    var massiv  = [TypeCategory.StartNow, TypeCategory.Program]
    var navbarShow = true
    var navbarHide = true
    
    private var bannerPlaylists:[MusicPlaylist] = []{
        didSet{
            pagerView.reloadData()
        }
    }
    
    private var beginPlaylists: [MusicPlaylist] = []{
        didSet{
            categotyTableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.automatic)
        }
    }
    
    private var popularPlaylists: [MusicPlaylist] = []{
        didSet{
            categotyTableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: UITableView.RowAnimation.automatic)
        }
    }
    
    lazy var imageView: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.red, for: .normal)
        btn.setImage(#imageLiteral(resourceName: "profileImage"), for: .normal)
        btn.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
        return btn
    }()
    
    @objc func imageTapped() -> Void {
        self.tabBarController?.selectedIndex = 3
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
    
    // MARK: - Lifecycle
    
    lazy var categotyTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StartNowTableViewCell.self, forCellReuseIdentifier: StartNowTableViewCell.name)
        tableView.register(CategotyTableViewCell.self, forCellReuseIdentifier: CategotyTableViewCell.name)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    lazy var bottomMeditatio: UIView = {
        let view = UIView(frame: CGRect.init(x: 0, y: topbarHeight, width: ConstraintConstants.width, height: ConstraintConstants.height * 0.7))
        return view
    }()
    
    lazy var howManyPeopleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .mainBlue
        label.text = "10500"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()
    
    lazy var peopleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .mainBlue
        label.text = "адам"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var nowInMeditationLabel:UILabel = {
        let label = UILabel()
        label.textColor = .mainBlue
        label.text = "қазір медитация жасап жатыр."
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    lazy var bottomOpenAllImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "OpenAll")
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.contentMode = UIView.ContentMode.scaleAspectFit
        image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(payView))
        tapGesture.numberOfTapsRequired = 1
        image.addGestureRecognizer(tapGesture)
        return image
    }()
    
    @objc func payView(){
        let vc = UnlockProgramsViewController(networkManager: networkManager)
        self.presentInFullScreen(NavigationController(rootViewController: vc), animated: false, completion: nil)
    }
    
    lazy var bottomBackroundImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "bottomBackround")
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        image.contentMode = UIView.ContentMode.scaleAspectFill
        return image
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
        setupUI()
        tabBarItem.setImageOnly()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupNavigationBar()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        
        if let subscribe = StorageManager.shared.subscribed{
            if subscribe{
                bottomOpenAllImageView.isHidden = true
            }
        }
    }
    
    func fetchData(){
        //BannerPlayists
        if let token = StorageManager.shared.token{
            print("token \(token)")
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
            
            
            networkManager.makeRequest(endpoint: Endpoints.getBeginPlaylists(token: token)) { (result: Result<MusicPlaylists>) in
                switch result {
                    case .failure(let errorMessage):
                        print(errorMessage)
                    case .success(let res):
                        if let musics = res.results{
                            self.beginPlaylists = musics
                        }
                }
            }
            
            
            networkManager.makeRequest(endpoint: Endpoints.getPopularPlaylists(token: token)) { (result: Result<MusicPlaylists>) in
                   switch result {
                       case .failure(let errorMessage):
                           print(errorMessage)
                       case .success(let res):
                           if let musics = res.results{
                               self.popularPlaylists = musics
                    }
                }
            }
            
            networkManager.makeRequest(endpoint: Endpoints.getUser(token: token)) { (result: Result<ProfileData>) in
                        print("Hello", result)
                        switch result {
                            case .failure(let errorMessage):
                                print(errorMessage)
                            case .success(let res):
                                if let firstName = res.firstName{
                                    self.title = "Салем, \(firstName)"
                                }
                                if let avatar = res.avatar{
                                    let resource = ImageResource(downloadURL: URL(string: avatar)!, cacheKey: avatar)
                                    self.imageView.imageView!.kf.setImage(with: resource)
                                }
                                StorageManager.shared.subscribed = res.subscribed
                                
                                
                                
            //                    self.profileImageView.image = UIImage(named: res.avatar!) ?? #imageLiteral(resourceName: "programImage")
                        }
                    }
            
        }
        
        
        
            
        
        
    }
    
    
    func setupNavigationBar() -> Void {
        //        self.title = "Сәлем, Нурайым"
        //     self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9688585069, green: 1, blue: 1, alpha: 1)
        //        localized(tableName: UserDefaults.standard.string(forKey: "lang")!)
        //        let right = UIBarButtonItem.init(image: #imageLiteral(resourceName: "Search"), style: .plain, target: self, action: #selector(searchButton))
        //        self.navigationItem.rightBarButtonItem = right
        
    }
    
    @objc func searchButton(){
        print("Search")
    }
    
    func setupConstraints(){
        view.addSubViews(views: [categotyTableView])
        topMeditatio.addSubViews(views: [descriptionLabel, pagerView, pageControl])
        bottomMeditatio.addSubViews(views: [bottomOpenAllImageView, bottomBackroundImageView, howManyPeopleLabel,peopleLabel,nowInMeditationLabel])
        
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
        
        
        bottomOpenAllImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(ConstraintConstants.s16)
            make.right.equalTo(-ConstraintConstants.s16)
            make.height.equalTo(ConstraintConstants.height*0.3)
        }
        
        bottomBackroundImageView.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.05)
            make.height.equalTo(ConstraintConstants.height*0.4)
        }
        
        
        howManyPeopleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ConstraintConstants.s16)
            make.width.equalTo(ConstraintConstants.s160)
            make.centerY.equalTo(bottomBackroundImageView)
            make.height.equalTo(ConstraintConstants.height*0.1)
        }
        
        peopleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(howManyPeopleLabel.snp.right).offset(8)
            make.top.equalTo(howManyPeopleLabel)
        }
        
        nowInMeditationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(peopleLabel.snp.bottom).offset(8)
            make.left.equalTo(peopleLabel)
            make.width.equalTo(ConstraintConstants.s128)
        }
        
        categotyTableView.tableHeaderView = topMeditatio
        categotyTableView.tableFooterView = bottomMeditatio
    }
    
    
    func getDataFromPopularPlaylist(){
//        let params = ["email": signInViewModel.email!.lowercased(), "password": signInViewModel.password!] as Parameters
//        network.makeRequest(endpoint: Endpoints.login(parameters: params )) { (result: Result<GetToken>) in
//            switch result {
//            case .failure(let errorMessage):
//                print(errorMessage)
//            case .success(let res):
//                print(res.token)
//                StorageManager.shared.token = res.token
//                self.appDelegate.navigateToTabBarViewController()
//            }
//        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showImage(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImage(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        moveAndResizeImage(for: Const.ImageSizeForLargeState)
        
    }

    // MARK: - Scroll View Delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        print(height)
        moveAndResizeImage(for: height)
    }
    
    
    // MARK: - Private methods
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Сәлем, Нурайым"
        
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.right.equalTo(-Const.ImageRightMargin)
        make.bottom.equalTo(navigationBar.snp.bottomMargin).offset(-Const.ImageBottomMarginForLargeState)
            make.width.height.equalTo(Const.ImageSizeForLargeState)
        }
        self.moveAndResizeImage(for: Const.ImageSizeForLargeState)
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        
        let coeff: CGFloat = {
            
            let delta = height - Const.NavBarHeightSmallState
            
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            
            return delta / heightDifferenceBetweenStates
            
        }()
        
        
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        
        
        let scale: CGFloat = {
            
            let sizeAddendumFactor = coeff * (1.0 - factor)
            
            return min(1.0, sizeAddendumFactor + factor)
            
        }()
        
        
        
        
        // Value of difference between icons for large and small states
        
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        
        let yTranslation: CGFloat = {
            
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
            
        }()
        
        
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        
        
        imageView.transform = CGAffineTransform.identity
            
            .scaledBy(x: scale, y: scale)
            
            .translatedBy(x: xTranslation, y: yTranslation)
        
    }
    private func resizeImageForLandscape() {
        let yTranslation = Const.ImageSizeForLargeState * Const.ScaleForImageSizeForLandscape
        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: Const.ScaleForImageSizeForLandscape, y: Const.ScaleForImageSizeForLandscape)
            .translatedBy(x: 0, y: yTranslation)
    }
    
    /// Show or hide the image from NavBar while going to next screen or back to initial screen
    ///
    /// - Parameter show: show or hide the image from NavBar
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = show ? 1.0 : 0.0
        }
    }
    
    
    

}




extension MainViewController: TYCyclePagerViewDataSource, TYCyclePagerViewDelegate {
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
        print("which123 \(index)")
        vc.data = bannerPlaylists[index]
        self.presentInFullScreen(NavigationController(rootViewController: vc), animated: false, completion: nil)
    }
    
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if massiv[indexPath.row] == .StartNow{
            let cell = tableView.dequeueReusableCell(withIdentifier: StartNowTableViewCell.name, for: indexPath) as! StartNowTableViewCell
            cell.beginPlaylists = self.beginPlaylists
            cell.rowTitleLabel.text = "Казiр бастаныз"
            cell.indexSelected = 0
            cell.delegate = self
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CategotyTableViewCell.name, for: indexPath) as! CategotyTableViewCell
            cell.popularPlaylists = self.popularPlaylists
            cell.rowTitleLabel.text = "Танымал"
            cell.indexSelected = 1
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        print(row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if .StartNow == massiv[indexPath.row]{
            return ConstraintConstants.height * 0.6
        }else{
            return ConstraintConstants.height * 0.4
        }
       
    }
}


extension MainViewController:ChangeViewDelegate {
    func pushDetail(index: Int, which: Int) {
        let playlist = index == 0 ? beginPlaylists : popularPlaylists
    
        let vc = DetailViewController(collectionViewLayout: StretchyHeaderLayout(), networkManager: networkManager)
        print("which123 \(which)")
        
        if playlist[which].available{
            vc.data = playlist[which]
            self.presentInFullScreen(NavigationController(rootViewController: vc), animated: false, completion: nil)
        }else{
            let vc = UnlockProgramsViewController(networkManager: networkManager)
            self.presentInFullScreen(NavigationController(rootViewController: vc), animated: false, completion: nil)
        }
    }

    func pushMore(index: Int){
        let playlist = index == 0 ? beginPlaylists : popularPlaylists
        let vc = DetailProgramViewController(networkManager: networkManager)
        vc.detailPlaylists = playlist
        navigationController?.pushViewController(vc, animated: true)
    }
}

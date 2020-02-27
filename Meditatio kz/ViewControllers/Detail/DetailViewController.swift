//
//  DetailViewController.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 21/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire
class DetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var data: MusicPlaylist?
    {
        didSet {
            fetchData()
        }
    }
    
    func setupHeaderProperties(){
        if let data = data{
            likeButton()
            
            let url = data.img
            let resource = ImageResource(downloadURL: URL(string: url)!, cacheKey: url)
            headerView?.imageView.kf.setImage(with: resource)
            headerView?.titleLabel.text = data.name
            headerView?.detailLabel.text = data.description
            headerView?.howManyMusicLabel.text = "\(trackList.count) сессия"
        }
    }
    
    func likeButton() -> Void {
        var image = UIImage()
        if data?.liked == true{
            image = #imageLiteral(resourceName: "like-1")
        }else{
            image = #imageLiteral(resourceName: "Object")
        }
        navigationItem.rightBarButtonItem?.image = image.withRenderingMode(.alwaysTemplate)
    }
    
    var trackList: [Track] = []{
        didSet{
            setupHeaderProperties()
            collectionView.reloadData()
        }
    }
    
    private let networkManager: NetworkManager
    
    init(collectionViewLayout layout: UICollectionViewLayout, networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(collectionViewLayout: layout)
//        collectionView.collectionViewLayout = layout
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCollectionViewLayout()
        setupCollectionView()
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(12345670)
    }
    
    fileprivate func setupNavigation(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Object"), style: .done, target: self, action: #selector(pressRightButton))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "navigationBack"), style: .done, target: self, action: #selector(pressBackButton))
    }
    
    @objc func pressBackButton(){
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func pressRightButton(){
        if let token = StorageManager.shared.token{
            if let liked = data?.liked{
                let params = ["value": data!.id] as Parameters
                let endpoint = liked ? Endpoints.patchUnlikeProgram(token: token, params: params) : Endpoints.patchLikeProgram(token: token, params: params)
                
                networkManager.makeRequest(endpoint: endpoint) { (result: Result<LikeUnlike>) in
                    switch result {
                        case .failure(let errorMessage):
                            print(errorMessage)
                        case .success(let res):
                            if let status = res.status{
                                print(status)
                            }
                    }
                }
            }
        }
        data?.liked = data?.liked == false ? true : false
        likeButton()
        print(12345)
    }
    
    
    
    fileprivate func setupCollectionViewLayout() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(MusicCollectionViewCell.self, forCellWithReuseIdentifier: MusicCollectionViewCell.name)
        
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.name)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        print(contentOffsetY)
        
        if contentOffsetY > 0 {
            headerView?.animator.fractionComplete = 0
            headerView?.animator.stopAnimation(true)
            headerView?.animator.finishAnimation(at: .current)
//            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
//                self.navigationController?.setToolbarHidden(true, animated: true)
//                print("Hide")
//            }, completion: nil)
            return
//        }else{
//            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//                self.navigationController?.setToolbarHidden(false, animated: true)
//                print("Unhide")
//            }, completion: nil)
        }
//
        headerView?.animator.fractionComplete = abs(contentOffsetY) / 100
    }
    
    
    
    @objc func minimizePlayerDetails() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
           
        })
    }
    
    func maximizePlayerDetails(episode: Track?, playlistEpisodes: [Track]) {
        
        if episode != nil {
//            playerDetailsView.episode = episode
        }
        
        if playlistEpisodes.count > 0 {
//            playerDetailsView.playlistEpisodes = playlistEpisodes
        }
        
    }
    
    var headerView: HeaderView?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.name, for: indexPath) as? HeaderView
        headerView?.delegate = self
        return headerView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: ConstraintConstants.height * 0.6)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCollectionViewCell.name, for: indexPath) as! MusicCollectionViewCell
        cell.oneTrack = trackList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 2 * ConstraintConstants.s16, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PlayerViewContoller(networkManager: networkManager)
        vc.playerDetailsView!.backroudImage.image =  headerView?.imageView.image
        vc.maximizePlayerDetails(episode: trackList[indexPath.row], playlistEpisodes: trackList)
        presentInFullScreen(vc, animated: true, completion: nil)
    }
    
}

extension DetailViewController: PlayMusicDelegate{
    func playMusic() {
        let vc = PlayerViewContoller(networkManager: networkManager)
        vc.maximizePlayerDetails(episode: trackList[0], playlistEpisodes: trackList)
        presentInFullScreen(vc, animated: true, completion: nil)
    }
}

extension DetailViewController{
    func fetchData(){
        if let token = StorageManager.shared.token{
            let params = ["value": data!.id] as Parameters
            networkManager.makeRequest(endpoint: Endpoints.getOneProgramTracks(token: token, params: params)) { (result: Result<PlaylistDetail>) in
                switch result {
                   case .failure(let errorMessage):
                       print(errorMessage)
                   case .success(let res):
                        if let trackList = res.tracks{
                            self.trackList = trackList
                    }
                }
            }
        }
    }
}

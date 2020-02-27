//
//  PlayerViewContoller.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 13/11/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit
import Alamofire

class PlayerViewContoller: UIViewController{
    
    //MARK:- Setup Functions
    weak var playerDetailsView = PlayerDetailsView.initFromNib()
    
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
        setupViews()
        fetchData()
        playerDetailsView?.whenButtonPressed = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default
    }
    
    func fetchData(){
        //BannerPlayists
        if let token = StorageManager.shared.token{
           print("token \(token)")
           networkManager.makeRequest(endpoint: Endpoints.getBackroundTracks(token: token)) { (result: Result<BackroundTraks>) in
               switch result {
                   case .failure(let errorMessage):
                       print(errorMessage)
                   case .success(let res):
                       if let musics = res.results{
                            print(musics)
                        self.playerDetailsView?.backroundTracks = musics
                       }
               }
            }
        }
    }
    
    func setupViews() -> Void {
        view.addSubview(playerDetailsView!)
        playerDetailsView?.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    func maximizePlayerDetails(episode: Track?, playlistEpisodes: [Track]) {
        if episode != nil {
            playerDetailsView?.episode = episode
        }
        if playlistEpisodes.count > 0 {
            playerDetailsView?.playlistEpisodes = playlistEpisodes
        }
    }
    
    
}

extension PlayerViewContoller: LikePressed{
    func likeOrUnlike(_ params: Parameters) {
        if let token = StorageManager.shared.token{
           print("token \(token)")
           networkManager.makeRequest(endpoint: Endpoints.patchlikeUnlikeTrack(token: token, params: params)) { (result: Result<LikeUnlike>) in
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
    
    func endMusic(_ params: Parameters) {
        if let token = StorageManager.shared.token{
           print("token \(token)")
            networkManager.makeRequest(endpoint: Endpoints.getEndOne(token: token, params: params)) { (result: Result<LikeUnlike>) in
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
}

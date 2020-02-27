


//
//  File.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 28/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit

class FavouriteViewController: UITableViewController {
    
    private var tracks: [Track] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image =  #imageLiteral(resourceName: "emptyIcon")
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var headerTableView: FavouriteHeaderView = {
        let view = FavouriteHeaderView(frame:CGRect.init(x: 0, y: 0, width: ConstraintConstants.width, height: ConstraintConstants.h260), networkManager: networkManager, type: TypeHeader.favorite)
        view.delegate = self
        return view
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
        tableView.backgroundView = UIImageView.init(image: #imageLiteral(resourceName: "emptyList"))
        tableView.backgroundView?.isHidden = true
        tableView.tableHeaderView = headerTableView
        // Do any additional setup after loading the view.
        view.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupViews()
        self.title = "Таңдаулылар"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerTableView.fetchData()
        fetchData()
    }
    
    func setupViews(){
        tableView.register(SessionCell.self, forCellReuseIdentifier: SessionCell.name)
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.separatorStyle = .none
    }
    
    
}


// Fetching Data
extension FavouriteViewController{
    func fetchData(){
        if let token = StorageManager.shared.token{
            //HeaderBannerPlayists
            networkManager.makeRequest(endpoint: Endpoints.getLikedTracks(token: token)) { (result: Result<TrackData>) in
                switch result {
                    case .failure(let errorMessage):
                        print(errorMessage)
                    case .success(let res):
                        if let musics = res.results{
                            if musics.isEmpty{
                                if self.headerTableView.isHidden{
                                    self.tableView.backgroundView?.isHidden = false
                                }else{
                                    self.tableView.backgroundView?.isHidden = true
                                    self.headerTableView.meditationLabel.isHidden = true
                                }
                                
                            }else{
                                self.tableView.backgroundView?.isHidden = true
                                self.tracks = musics
                            }
                            
                        }
                }
            }
        }
    }
}

extension FavouriteViewController:ChangeViewDelegate {
    func pushDetail(index: Int, which: Int) {
        let vc = DetailViewController(collectionViewLayout: StretchyHeaderLayout(), networkManager: networkManager)
        vc.data = headerTableView.programs[which]
        self.presentInFullScreen(NavigationController(rootViewController: vc), animated: false, completion: nil)
    }
    
    func pushMore(index: Int){
        let vc = DetailProgramViewController(networkManager: networkManager)
        vc.detailPlaylists = headerTableView.programs
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension FavouriteViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConstraintConstants.h70
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SessionCell.name) as! SessionCell
        cell.data = tracks[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlayerViewContoller(networkManager: networkManager)
        vc.maximizePlayerDetails(episode: tracks[indexPath.row], playlistEpisodes: tracks)
        presentInFullScreen(vc, animated: true, completion: nil)
    }
}


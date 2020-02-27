//
//  PlayerDetailsView.swift
//  PodcastsCourseLBTA
//
//  Created by Nazhmeddin  on 2/28/18.
//  Copyright © 2018 Nazhmeddin. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import SDWebImage
import Alamofire

protocol LikePressed {
    func likeOrUnlike(_ params: Parameters)
    func endMusic(_ params: Parameters)
}

class PlayerDetailsView: UIView {
    
    var old = -1
    var whenButtonPressed:LikePressed?
    
    
    var episode: Track! {
        didSet {
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: .zero, requestHandler: { (size) -> UIImage in
                return #imageLiteral(resourceName: "hello")
            })
            
            if let like = episode.liked {
                likeButton.setImage( like ?  #imageLiteral(resourceName: "like-1") : #imageLiteral(resourceName: "Like"), for: .normal)
            }
            
            self.playPauseButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)

            
            titleLabel.text = episode.name
            setupNowPlayingInfo()
            setupAudioSession()
            playEpisode()
            
            
            if old == -1{
                NotificationCenter.default.post(name: .whichPlayed, object: nil, userInfo: ["id": episode.id,"old": old])
                old = episode.id
            }else{
                NotificationCenter.default.post(name: .whichPlayed, object: nil, userInfo: ["id": episode.id, "old": old])
                old = episode.id
            }
            
           
        
            
        }
    }
    
    fileprivate func setupNowPlayingInfo() {
        var nowPlayingInfo = [String: Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.name
//        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author.name
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func clearRemotePlayerInfo() { // call after stop button pressed
        try? AVAudioSession.sharedInstance().setActive(false)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
    }
    
    fileprivate func playEpisode() {
        if episode.fileUrl != nil && episode.fileUrl != ""{
            playEpisodeUsingFileUrl()
        } else {
//            print("Trying to play episode at url:", episode.url)
            let headers = ["Authorization":  "JWT "+StorageManager.shared.token!]
            let avAsset = AVURLAsset(url: URL(string: episode.url)!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
            let avItem = AVPlayerItem(asset: avAsset)
            player.replaceCurrentItem(with: avItem)
            player.play()
            
        }
    }
    
    fileprivate func playEpisodeUsingFileUrl() {
        print("Attempt to play episode with file url:", episode.fileUrl ?? "")
        
        // let's figure out the file name for our episode file url // let's figure out the file name for our episode file url
        guard let fileURL = URL(string: episode.fileUrl ?? "") else { return }
        let fileName = fileURL.lastPathComponent
        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        trueLocation.appendPathComponent(fileName)
        print("True Location of episode:", trueLocation.absoluteString)
        let playerItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    lazy var player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    var timeObserverToken: Any?
    
    fileprivate func observePlayerCurrentTime() {
        
        let interval = CMTimeMake(value: 1, timescale: 2)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            let durationTime = self?.player.currentItem?.duration
            let cur = time.toDisplayString()
            let dis = durationTime?.toDisplayString()
            if let selfV = self{
                if cur == dis{
                    print("episode fineshed")
                    let params = ["value": self!.episode.id] as Parameters
                    self!.whenButtonPressed?.endMusic(params)
                }
                
                if selfV.repitBool{
                    if cur == dis{
                        print("Soni")
                        selfV.episode = self?.episode
                    }else{
                        selfV.currentTimeLabel.text = cur
                        selfV.durationLabel.text = dis
                        selfV.updateCurrentTimeSlider(durationTime!)
                    }
                }else{
                    if cur == dis{
                        print("Soni")
                        selfV.handleNextTrack()
                        selfV.currentTimeLabel.text = cur
                        selfV.durationLabel.text = dis
                    }else{
                        selfV.currentTimeLabel.text = cur
                        selfV.durationLabel.text = dis
                        selfV.updateCurrentTimeSlider(durationTime!)
                    }
                }
            }
            
        }
    }
    
    fileprivate func updateCurrentTimeSlider(_ durationTime:CMTime) {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1000))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    var panGesture: UIPanGestureRecognizer!
    
    fileprivate func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myviewTapped))
        tapGesture.numberOfTapsRequired = 2
        maximizedStackView.addGestureRecognizer(tapGesture)
    }
    
    @objc func myviewTapped(_ recognizer: UIGestureRecognizer) {
        maximizedStackView.isHidden = true
        hidenViewIsPlaying.isHidden = false
        hidenViewIsPlaying.alpha = 0.5
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.hidenViewIsPlaying.alpha = 1.0
               }, completion: nil)
        }
        
        
        print("button is tapped")
    }
    
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {

    }
    
    fileprivate func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionErr {
            print("Failed to activate session:", sessionErr)
        }
    }
    
    fileprivate func setupRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)

            self.setupElapsedTime(playbackRate: 1)
            return .success
        }
        commandCenter.playCommand.isEnabled = true


        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.playPauseButton.setImage(#imageLiteral(resourceName: "playerButton"), for: .normal)
            self.setupElapsedTime(playbackRate: 0)
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true


        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
        commandCenter.togglePlayPauseCommand.isEnabled = true
        
        commandCenter.nextTrackCommand.addTarget { [weak self] event in
            guard let self = self else {return .commandFailed}
            self.handleNextTrack()
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { [weak self] event in
            guard let self = self else {return .commandFailed}
            self.handlePrevTrack()
            return .success
        }
        
    }
    
    var playlistEpisodes = [Track]()
    
    @objc fileprivate func handlePrevTrack() {
        DispatchQueue.main.async { [unowned self] in
            self.playPauseButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
        }
        print(playlistEpisodes.count)
        if playlistEpisodes.isEmpty {
            return
        }
        
        if shaffleBool{
            let index =  Int(arc4random_uniform(UInt32(playlistEpisodes.count)))
            let prevEpisode: Track
            prevEpisode = playlistEpisodes[index]
            self.episode = prevEpisode
            
        }else{
            let currentEpisodeIndex = playlistEpisodes.firstIndex { (ep) -> Bool in
                return self.episode.name == ep.name && self.episode.id == ep.id
            }
            guard let index = currentEpisodeIndex else { return }
            let prevEpisode: Track
            if index == 0 {
                let count = playlistEpisodes.count
                prevEpisode = playlistEpisodes[count - 1]
            } else {
                prevEpisode = playlistEpisodes[index - 1]
            }
            self.episode = prevEpisode
        }
    }
    
    @objc fileprivate func handleNextTrack() {
        DispatchQueue.main.async { [unowned self] in
            self.playPauseButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
            
        }
        print(playlistEpisodes.count)
        if playlistEpisodes.count == 0 {
            return
        }
        
        
        if shaffleBool{
            let index =  Int(arc4random_uniform(UInt32(playlistEpisodes.count)))
            let prevEpisode: Track
            prevEpisode = playlistEpisodes[index]
            self.episode = prevEpisode
            
        }
        else{
            let currentEpisodeIndex = playlistEpisodes.firstIndex { (ep) -> Bool in
                return self.episode.name == ep.name && self.episode.id == ep.id
            }
            
            guard let index = currentEpisodeIndex else { return }
            
            let nextEpisode: Track
            if index == playlistEpisodes.count - 1 {
                nextEpisode = playlistEpisodes[0]
            } else {
                nextEpisode = playlistEpisodes[index + 1]
            }
            
            self.episode = nextEpisode
        }
    }
    
    fileprivate func setupElapsedTime(playbackRate: Float) {
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
    }
    
    fileprivate func observeBoundaryTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        // player has a reference to self
        // self has a reference to player
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            print("Episode started playing")
            self?.enlargeEpisodeImageView()
            self?.setupLockscreenDuration()
        }
    }
    
    fileprivate func setupLockscreenDuration() {
        guard let duration = player.currentItem?.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
    }
    
    fileprivate func setupInterruptionObserver() {
        // don't forget to remove self on deinit
//        NotificationCenter.default.addObserver
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    @objc fileprivate func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        
        if type == AVAudioSession.InterruptionType.began.rawValue {
            print("Interruption began")
            playPauseButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
            
            
        } else {
            print("Interruption ended...")
            
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                player.play()
                playPauseButton.setImage(#imageLiteral(resourceName: "playerButton"), for: .normal)
            }
         
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupRemoteControl()
        setupGestures()
        setupInterruptionObserver()
        
        observePlayerCurrentTime()
        
        observeBoundaryTime()

        currentTimeSlider.setThumbImage(UIImage(),for: .normal)
        currentTimeSlider.minimumTrackTintColor = .mainPurple
        
        setupHidenViewIsPlaying()
        setupHiddenView()
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    static func initFromNib() -> PlayerDetailsView {
        return Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView
    }
    
    //MARK:- IB Actions and Outlets
    
    lazy var miniEpisodeImageView: UIImageView = {
       return UIImageView()
    }()
    
    @IBOutlet weak var miniTitleLabel: UILabel!
    @IBOutlet weak var miniSubtitleLabel: UILabel!
    
    
    
    @IBOutlet weak var miniFastForwardButton: UIButton! {
        didSet {
            miniFastForwardButton.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
            miniFastForwardButton.addTarget(self, action: #selector(handleFastForward(_:)), for: .touchUpInside)
        }
    }
    
    
   
    @IBOutlet weak var maximizedStackView: UIView!
    
    @IBAction func handleCurrentTimeSliderChange(_ sender: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1000)
        
        player.seek(to: seekTime)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
    }
    
    @IBAction func handleFastForward(_ sender: Any) {
        print("handleNextTrack")
        handleNextTrack()
        print(playlistEpisodes.count)
    }
    
    @IBAction func handleRewind(_ sender: Any) {
        print("handlePrevTrack")
        handlePrevTrack()
        print(playlistEpisodes.count)
    }
    
    fileprivate func seekToCurrentTime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
 
    
    @IBOutlet weak var currentTimeSlider: UISlider!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    @IBAction func handleDismiss(_ sender: Any) {
        if let window = UIApplication.shared.delegate?.window {
            if let topController = window?.visibleViewController() as? PlayerViewContoller{
                clearRemotePlayerInfo()
                player.pause()
                removePeriodicTimeObserver()
                player.replaceCurrentItem(with: nil)
                print(1243567)
                if let presented = (topController.presentingViewController as? NavigationController)?.viewControllers[0] as? DetailViewController {
                    print(098765432)
                    presented.fetchData()
                }
                topController.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    fileprivate func enlargeEpisodeImageView() {
        
    }
    
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.65, y: 0.8)
    
    fileprivate func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = self.shrunkenTransform
        })
    }
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 10
            episodeImageView.clipsToBounds = true
            episodeImageView.transform = shrunkenTransform
        }
    }
    
    var shaffleBool = false
    @IBAction func shaffle(_ sender: UIButton) {
        if shaffleBool{
            sender.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            shaffleBool = false
        }else{
            sender.tintColor = .mainPurple
            shaffleBool = true
        }
    }

    var repitBool = false
    @IBAction func repitButton(_ sender: UIButton) {
        if repitBool{
            sender.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            repitBool = false
        }else{
            sender.tintColor = .mainPurple
            repitBool = true
        }
        
    }
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(#imageLiteral(resourceName: "playerButton"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @objc func handlePlayPause() {
        print("Trying to play and pause")
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pauseButton"), for: .normal)
            backroundMusic.player.play()
//            self.setupElapsedTime(playbackRate: 1)
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "playerButton"), for: .normal)
            backroundMusic.player.pause()
            shrinkEpisodeImageView()
//            self.setupElapsedTime(playbackRate: 0)
        }
    }
    
    @IBOutlet weak var addButtonOutlet: UIButton!
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let index = playlistEpisodes.firstIndex { (ep) -> Bool in
            return self.episode.id == ep.id
        }
//        if let my = playlistEpisodes[index!].is_mymusic{
//            if my{
//                whenButtonPressed?.buttonAddToMusic(index!, bool: true)
//                addButtonOutlet.setImage(#imageLiteral(resourceName: "add"), for: .normal)
//            }else{
//                whenButtonPressed?.buttonAddToMusic(index!, bool: false)
//                addButtonOutlet.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
//            }
//        }
    }
    
    
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        guard let index = playlistEpisodes.firstIndex(where: { $0.id == episode.id}) else{ return }
        if let like = playlistEpisodes[index].liked{
            if like{
                sender.setImage(#imageLiteral(resourceName: "Like") , for: .normal)
                let params = ["value": episode.id, "type": "unlike"] as Parameters
                whenButtonPressed?.likeOrUnlike(params)
                playlistEpisodes[index].liked = false
                
            }else{
                sender.setImage(#imageLiteral(resourceName: "like-1") , for: .normal)
                let params = ["value": episode.id, "type": "like"] as Parameters
                whenButtonPressed?.likeOrUnlike(params)
                playlistEpisodes[index].liked = true
            }
        }
        
       
        
////        index
        
        
        
    }
    
    
    
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        maximizedStackView.isHidden = true
        hiddenView.isHidden = false
    }
    
 
    @IBOutlet weak var hiddenView: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self, name:  AVAudioSession.interruptionNotification, object: nil)
    }
    
    var layout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.register(OneCollectionViewCell.self, forCellWithReuseIdentifier: OneCollectionViewCell.name)
        return cv
    }()
    
    lazy var pageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Фондық дыбыстар"
        label.textColor = .mainBlue
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    
    @IBOutlet weak var backroudImage: UIImageView!
    
    lazy var buttonCancelButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "cancelButton"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func cancelButtonPressed(){
        maximizedStackView.isHidden = false
        hiddenView.isHidden = true
    }
    
    lazy var musicVoiseSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.trackWidth = 5
        slider.minimumTrackTintColor = .mainPurple
        slider.maximumTrackTintColor = UIColor.mainPurple.withAlphaComponent(0.2)
        
        slider.maximumValue = 0.5
        slider.minimumValue = 0
        slider.setValue(50, animated: false)
        
        slider.setThumbImage(#imageLiteral(resourceName: "current"), for: .normal)
        slider.addTarget(self, action: #selector(changeVlaue(_:)), for: .valueChanged)
        return slider
    }()
    
    @objc func changeVlaue(_ sender: UISlider) {
        backroundMusic.player.volume = sender.value
        print("value is" , sender.value);
    }
    
    func setupHiddenView(){
        self.hiddenView.addSubViews(views: [collectionView, pageTitleLabel, buttonCancelButton, musicVoiseSlider])
        
        pageTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(collectionView.snp.top)
            make.centerX.equalToSuperview()
            make.top.equalTo(UIApplication.shared.statusBarFrame.size.height)
        }
        
        buttonCancelButton.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.height.width.equalTo(40)
            make.centerY.equalTo(pageTitleLabel)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.height/10)
            make.bottom.equalToSuperview().offset(-ConstraintConstants.height/10)
            make.left.right.equalToSuperview()
        }
        
        musicVoiseSlider.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-ConstraintConstants.height/32)
            make.height.equalTo(4)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let margin = CGFloat(81)
        let widthCell = (ConstraintConstants.width - margin)/3
        layout.itemSize = CGSize(width: widthCell , height: ConstraintConstants.height/5)
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    var backroundTracks:[BTrack] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    @IBOutlet weak var hidenViewIsPlaying: UIView!
    
    lazy var hidenViewIsPlayingImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Background"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    func setupHidenViewIsPlaying() -> Void{
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewShow))
        tapGesture.numberOfTapsRequired = 1
        hidenViewIsPlaying.addGestureRecognizer(tapGesture)
        
        hidenViewIsPlaying.addSubview(hidenViewIsPlayingImage)
        hidenViewIsPlayingImage.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    @objc func viewShow() -> Void {
        hidenViewIsPlaying.isHidden = true
        maximizedStackView.isHidden = false
        print("viewShow")
    }
    
    
    
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        if let window = UIApplication.shared.delegate?.window {
            if let topController = window?.visibleViewController() as? PlayerViewContoller{
                let text = "This is the text....."
                let textShare = [text]
                let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = topController.view
                topController.present(activityViewController, animated: true, completion: nil)

            }
        }
        
    }
    
    var backroundMusic = BackroundMusicManager()
}


extension PlayerDetailsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backroundTracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OneCollectionViewCell.name, for: indexPath) as! OneCollectionViewCell
        cell.oneHot = backroundTracks[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row, backroundTracks[indexPath.row])
        backroundMusic.episode = backroundTracks[indexPath.row]
    }
}


extension UISlider {
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }
}

// EndMusic
//extension PlayerDetailsView{
//    func didFinish
//}

import UIKit
import AVKit
import MediaPlayer


class BackroundMusicManager: NSObject {
    
    var url: String?
    
    var episode: BTrack! {
        didSet {
            if episode.url == self.url{
                if player.timeControlStatus == .paused {
                    player.play()
                } else {
                    player.pause()
                }
            }else{
                print(1243567)
                setupAudioSession()
                playEpisode()
                self.url = episode.url
            }
        }
    }
    
    fileprivate func playEpisode() {
        let headers = ["Authorization":  "JWT "+StorageManager.shared.token!]
        let avAsset = AVURLAsset(url: URL(string: episode.url)!, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
        let avItem = AVPlayerItem(asset: avAsset)
        player.replaceCurrentItem(with: avItem)
        player.volume = 0.5
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { (_) in
            self.player.seek(to: CMTime.zero)
            self.player.play()
        }
        player.play()
    }
    
    fileprivate func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionErr {
            print("Failed to activate session:", sessionErr)
        }
    }


    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:  .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    
}

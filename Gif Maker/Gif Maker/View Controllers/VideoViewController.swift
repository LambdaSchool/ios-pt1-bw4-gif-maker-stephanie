//
//  VideoViewController.swift
//  Gif Maker
//
//  Created by Stephanie Bowles on 1/10/20.
//  Copyright © 2020 Stephanie Bowles. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoViewController: UIViewController {

    @IBOutlet weak var gifView: UIImageView!
    
    @IBOutlet weak var videoView: VideoPlayerView!
    var gifURL: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
         
    }
    
    @IBAction func pickVideoButtonTapped(_ sender: Any) {
        gifView.isHidden = true
        setupView()
    }
    
    
    @IBAction func exportAsGifButtonTapped(_ sender: Any) {
        
        let movieURL = URL(fileURLWithPath: Bundle.main.path(forResource: "QuickVid", ofType: "MOV")!)
        
        convertToGif(movieURL)
    }
    
    private func setupView() {
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "QuickVid", ofType: "MOV")!)
        
        let player = AVPlayer(url: path)
        
        let newLayer = AVPlayerLayer(player: player)
        
        newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
             
   
        newLayer.frame = self.videoView.bounds
   self.videoView.layer.addSublayer(newLayer)
 
        
        
        player.play()
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoViewController.videoDidPlayToEnd(_ :)), name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"), object: player.currentItem)
        
    }
    
    @objc func videoDidPlayToEnd(_ notification: Notification) {
        let player: AVPlayerItem = notification.object as! AVPlayerItem
        player.seek(to: CMTime.zero)
    }

    
    
    func convertToGif(_ movieURL: URL) {
            let movieAsset = AVURLAsset(url: movieURL as URL)
            
         
            let duration = CMTimeGetSeconds(movieAsset.duration)
            let track = movieAsset.tracks(withMediaType: AVMediaType.video).first!
            let frameRate = track.nominalFrameRate
  
            
            Regift.createGIFFromSource(movieURL as URL, startTime: 0.0, duration: Float(duration), frameRate: Int(frameRate)) { (result) in
                DispatchQueue.main.async {
                self.gifURL = result
                self.gifView.isHidden = false
                self.videoView.isHidden = true
                self.gifView.loadGif2(url: self.gifURL!)
                    
                let activityVC = UIActivityViewController(activityItems: [self.gifURL!], applicationActivities: nil)
                    activityVC.popoverPresentationController?.sourceView = self.view
                                      self.present(activityVC, animated: true, completion: nil)
                                  }
                }
         
        }
}


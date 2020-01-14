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
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
    }
    
    @IBAction func pickVideoButtonTapped(_ sender: Any) {
        gifView.isHidden = true
        setupView()
    }
    
    
    @IBAction func exportAsGifButtonTapped(_ sender: Any) {
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

}


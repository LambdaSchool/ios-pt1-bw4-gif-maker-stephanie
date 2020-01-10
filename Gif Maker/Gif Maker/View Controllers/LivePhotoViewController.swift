//
//  ViewController.swift
//  Gif Maker
//
//  Created by Stephanie Bowles on 1/7/20.
//  Copyright © 2020 Stephanie Bowles. All rights reserved.
//

import UIKit

import Photos
import PhotosUI
import MobileCoreServices
import AVFoundation
import AVKit


class LivePhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var livePhotoView: PHLivePhotoView!
    @IBOutlet var pickLivePhotoButton: UIButton!
    
    var livePhotoAsset: PHAsset?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageView.loadGif(name: "catgiphy")
        imageView.isHidden = true
        livePhotoView.isHidden = true
    }
    
    func load(gif: String) {
        imageView.isHidden = false 
        imageView.loadGif(name: gif)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton){
        switch sender.tag {
        case 0:
            load(gif: "catgiphy")
        case 1:
            load(gif: "None")
        default:
            load(gif: "None")
        }
    }
    
    
}


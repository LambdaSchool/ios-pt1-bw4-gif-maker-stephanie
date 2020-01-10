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


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var livePhotoView: PHLivePhotoView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageView.loadGif(name: "catgiphy")
    }
    
    func load(gif: String) {
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


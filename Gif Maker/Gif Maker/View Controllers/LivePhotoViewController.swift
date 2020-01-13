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


class LivePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHLivePhotoViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var livePhotoView: PHLivePhotoView!
    @IBOutlet var pickLivePhotoButton: UIButton!
    
    var livePhotoAsset: PHAsset?
    var photoURL: URL?
    var videoURL: URL?
    var audioPlayer: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageView.loadGif(name: "catgiphy")
        imageView.isHidden = true
        livePhotoView.isHidden = true
        livePhotoView.delegate = self
        
    }
    
    func load(gif: String) {
        imageView.isHidden = false 
        imageView.loadGif(name: gif)
    }
  
    @IBAction func buttonPressed(_ sender: UIButton){
        switch sender.tag {
        case 0:
            load(gif: "catgiphy")
//        case 1:
//             let picker = UIImagePickerController()
//
        default:
            load(gif: "None")
        }
    }
    
    @IBAction func pickPhoto(_ sender: AnyObject) {
    let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = false
        picker.delegate = self
    picker.mediaTypes = [kUTTypeLivePhoto as String, kUTTypeImage as String]

     present(picker, animated: true, completion: nil)
    }
    
//MARK: UIImagePickerControllerDelegate
       
//    func imagePickerController(_ picker: UIImagePickerController,
//    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//         dismiss(animated: true, completion: nil)
//    }
//
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
       if mediaType == kUTTypeLivePhoto {
        guard let livePhoto = info[UIImagePickerController.InfoKey.livePhoto] as? PHLivePhoto else {
               self.postAlert("Photo Picker", message: "Could not retrieve the picked photo.")
               return;
           }
           self.livePhotoView.livePhoto = livePhoto
           
       } else {
           self.postAlert("It seems a live photo was not selected.", message:"Try again.")
       }
       dismiss(animated: true)
   }
    
}


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
        livePhotoView.isHidden = false
        livePhotoView.delegate = self
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       configureLoop()
    }
    
    
    func configureLoop(){
         if self.livePhotoView.livePhoto != nil {
            self.livePhotoView.startPlayback(with: .hint)
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { () -> Void in
//                                self.livePhotoView.stopPlayback()
////                    self.livePhotoView.startPlayback(with: .hint)
//                             }
                }
    }
    func load(gif: String) {
        imageView.isHidden = false 
        imageView.loadGif(name: gif)
    }
  
    @IBAction func buttonPressed(_ sender: UIButton){
        switch sender.tag {
        case 0:
            livePhotoView.isHidden = true
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
        imageView.isHidden = true
        livePhotoView.isHidden = false
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
        configureLoop()
   }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
//        configureLoop() //very hacky looop
    }
}


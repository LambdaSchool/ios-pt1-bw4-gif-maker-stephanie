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
    
    @IBOutlet weak var exportButton: UIButton!
    var livePhotoAsset: PHAsset?
     var livePhotoBadgeLayer = CALayer()
    var photoURL: URL?
    var videoURL: URL?
    var audioPlayer: AVAudioPlayer?
    var gifURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageView.loadGif(name: "catgiphy")
        imageView.isHidden = true
        livePhotoView.isHidden = true
        livePhotoView.delegate = self

    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       configureLoop()
       configureLivePhotoBadge()
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
    func configureLivePhotoBadge(){
       
        let livePhotoBadge = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
             
             guard let livePhotoBadgeImage = livePhotoBadge.cgImage else {
                 return
             }
             
             self.livePhotoBadgeLayer.frame = livePhotoView.bounds
            self.livePhotoBadgeLayer.contentsGravity = CALayerContentsGravity.topLeft
             self.livePhotoBadgeLayer.isGeometryFlipped = true
             self.livePhotoBadgeLayer.contentsScale = UIScreen.main.scale
             
             self.livePhotoBadgeLayer.contents = livePhotoBadgeImage
             livePhotoView.layer.addSublayer(self.livePhotoBadgeLayer)
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
    
    @IBAction func exportButtonPressed(_ sender: UIButton) {
        
       if exportButton.titleLabel?.text == "Export as GIF" {
                
        guard let livePhoto = self.livePhotoView.livePhoto else {return}
        let resources = PHAssetResource.assetResources(for: livePhoto)
                   for resource in resources {
                       if resource.type == .pairedVideo {
                           self.getMovieData(resource)
                           break
                       }
                   }
               } else {
                   let activityVC = UIActivityViewController(activityItems: [gifURL!], applicationActivities: nil)
                   activityVC.popoverPresentationController?.sourceView = self.view
                   self.present(activityVC, animated: true, completion: nil)
               }
    }
    
    
    func getMovieData(_ resource: PHAssetResource) {
        let movieURL = URL(fileURLWithPath: (NSTemporaryDirectory()).appending("video.mov"))
               removeFileIfExists(fileURL: movieURL)

               
               PHAssetResourceManager.default().writeData(for: resource, toFile: movieURL as URL, options: nil) { (error) in
                   if error != nil{
                       print("Could not write video file")
                   } else {
                       self.convertToGif(movieURL)
                   }
               }
    }
    
    
    func removeFileIfExists(fileURL: URL) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
            }
            catch {
                print("Could not delete existing file")
            }
        }
    }
    
    func convertToGif(_ movieURL: URL) {
        let movieAsset = AVURLAsset(url: movieURL as URL)
        
     
        let duration = CMTimeGetSeconds(movieAsset.duration)
        let track = movieAsset.tracks(withMediaType: AVMediaType.video).first!
        let frameRate = track.nominalFrameRate
        
        gifURL = URL(fileURLWithPath: (NSTemporaryDirectory()).appending("file.gif"))
        removeFileIfExists(fileURL: gifURL!)
        
        Regift.createGIFFromSource(movieURL as URL, startTime: 0.0, duration: Float(duration), frameRate: Int(frameRate)) { (result) in
            DispatchQueue.main.async {
            self.imageView.isHidden = false
            self.livePhotoView.isHidden = true
                self.imageView.loadGif2(url: self.gifURL!)
            }
        }
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
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
           self.livePhotoBadgeLayer.opacity = 0.0
       }
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
//        configureLoop() //very hacky looop
         self.livePhotoBadgeLayer.opacity = 1.0
    }
}


//
//  VideoPlayerView.swift
//  Gif Maker
//
//  Created by Stephanie Bowles on 1/14/20.
//  Copyright © 2020 Stephanie Bowles. All rights reserved.
//

import UIKit

class VideoPlayerView: UIView {
var playerLayer: CALayer?

override func layoutSublayers(of layer: CALayer) {
     super.layoutSublayers(of: layer)
     playerLayer?.frame = self.bounds
  }
}

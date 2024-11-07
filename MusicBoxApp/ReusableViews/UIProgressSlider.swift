//
//  CustomSlider.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 07/11/24.
//
import UIKit

class UIProgressSlider: UISlider {
   let trackHeight: CGFloat = 6
   override func trackRect(forBounds bounds: CGRect) -> CGRect {
      let track = super.trackRect(forBounds: bounds)
      return CGRect(x: track.origin.x, y: track.origin.y, width: track.width, height: trackHeight)
   }
}

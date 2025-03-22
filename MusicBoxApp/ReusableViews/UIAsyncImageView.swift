//
//  UIAsyncImageView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 26/10/24.
//
import UIKit
import Kingfisher

class UIAsyncImageView: UIImageView {
  var imageURL: URL? {
    didSet {
      guard let imageURL else { return }
      self.kf.setImage(with: imageURL)
    }
  }
  
  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

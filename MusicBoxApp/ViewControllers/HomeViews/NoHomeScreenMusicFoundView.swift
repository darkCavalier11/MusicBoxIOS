//
//  NoHomeScreenMusicFoundView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 12/11/24.
//

import UIKit

class NoHomeScreenMusicFoundView: UIStackView {
  private let noHomeScreenMusicFoundLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Start searching and playing a few songs, we will keep suggesting based on your play."
    label.font = .preferredCustomFont(forTextStyle: .body)
    label.numberOfLines = 4
    return label
  }()
  
  private let noHomeScreenMusicFoundImage: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    guard let image = UIImage(named: "HomeIllustration") else { return imageView }
    imageView.image = image
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    let aspectRatio = image.size.width / image.size.height
    
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 250),
      imageView.heightAnchor.constraint(equalToConstant: 250 / aspectRatio),
    ])
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.addArrangedSubview(noHomeScreenMusicFoundImage)
    self.addArrangedSubview(noHomeScreenMusicFoundLabel)
    self.axis = .vertical
    self.spacing = 12
    self.alignment = .center
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

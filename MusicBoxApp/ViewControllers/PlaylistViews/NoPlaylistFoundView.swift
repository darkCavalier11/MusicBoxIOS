//
//  NoPlaylistFoundView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 24/10/24.
//

import UIKit

class NoPlaylistFoundView: UIStackView {
  private let noPlaylistFoundLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "You haven't created any playlist yet. Swipe on the song and add/create a playlist."
    label.font = .preferredCustomFont(forTextStyle: .body)
    label.numberOfLines = 4
    return label
  }()
  
  private let noPlaylistFoundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    guard let image = UIImage(named: "NoPlaylistFound") else { return imageView }
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
    self.addArrangedSubview(noPlaylistFoundImageView)
    self.addArrangedSubview(noPlaylistFoundLabel)
    self.axis = .vertical
    self.spacing = 12
    self.alignment = .center
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

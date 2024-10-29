//
//  MusicPlayingBarView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 28/10/24.
//

import UIKit

class MusicPlayingBarView: UIView {  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .systemBackground
    self.layer.shadowColor = UIColor.accent.cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: -8)
    self.layer.shadowOpacity = 0.2
    self.layer.shadowRadius = 8
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.addArrangedSubview(musicTitleLabel)
    stackView.addArrangedSubview(musicArtistLabel)
    
    self.addSubview(imageView)
    self.addSubview(stackView)
    self.addSubview(playPauseButton)
    self.addSubview(nextMusicButton)
    self.addSubview(progressBar)
    
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
      imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
      imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
      imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
      
      stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
      stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5),
      stackView.trailingAnchor.constraint(lessThanOrEqualTo: playPauseButton.leadingAnchor, constant: -10),
      
      nextMusicButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
      nextMusicButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      
      playPauseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      playPauseButton.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
      
      progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      progressBar.heightAnchor.constraint(equalToConstant: 5),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "music_playing_bar")
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 8
    imageView.image = UIImage(named: "NoPlaylistFound")
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let musicTitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Chiring Chiring Chiring Chiring Chiring Chiring Chiring Chiring Chiring Chiring Chiring Chiring"
    label.font = .preferredCustomFont(forTextStyle: .body, fontName: UIFont.RethinkSans.bold.rawValue)
    label.textColor = .label
    return label
  }()
  
  private let musicArtistLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Huamne Sagar Huamne SagarHuamne Sagar Huamne Sagar Huamne Sagar Huamne Sagar Huamne Sagar Huamne Sagar"
    label.font = .preferredCustomFont(forTextStyle: .caption2)
    label.textColor = .secondaryLabel
    return label
  }()
  
  private let playPauseButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(
      UIImage(systemName: "play.fill"),
      for: .normal
    )
    button.tintColor = .label
    return button
  }()
  
  private let nextMusicButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(
      UIImage(systemName: "forward.fill"),
      for: .normal
    )
    button.tintColor = .label
    return button
  }()
  
  private let progressBar: UIProgressView = {
    let progressBar = UIProgressView()
    progressBar.translatesAutoresizingMaskIntoConstraints = false
    progressBar.progress = 0.63
    progressBar.progressTintColor = .accent
    return progressBar
  }()
}


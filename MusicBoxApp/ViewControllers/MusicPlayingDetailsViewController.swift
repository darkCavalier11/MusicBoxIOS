//
//  MusicPlayingDetailsViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 29/10/24.
//

import UIKit
import MusicBox

class MusicPlayingDetailsViewController: UIViewController {
  let musicItem = MusicItem(
    title: "Ed Sheeran - Dive [Official Audio]",
    publisherTitle: "Ed Sheeran",
    runningDurationInSeconds: 239,
    musicId: "Wv2rLZmbPMA",
    smallestThumbnail: "https://i.ytimg.com/vi/Wv2rLZmbPMA/hqdefault.jpg?sqp=-oaymwEjCOADEI4CSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLCPeXOnpH6AroaxxXnIjB2IERKo0Q",
    largestThumbnail:  "https://i.ytimg.com/vi/Wv2rLZmbPMA/hqdefault.jpg?sqp=-oaymwEjCOADEI4CSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLCPeXOnpH6AroaxxXnIjB2IERKo0Q"
  )
  
  
  private lazy var musicThumbnail: UIAsyncImageView = {
    let imageView = UIAsyncImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    // TODO: - Place a placeholder image
    imageView.imageURL = URL(string: musicItem.largestThumbnail)
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 12
    return imageView
  }()
  
  private lazy var musicTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = musicItem.title
    label.font = .preferredCustomFont(forTextStyle: .title3, fontName: UIFont.RethinkSans.bold.rawValue)
    label.textColor = .label
    label.numberOfLines = 2
    return label
  }()
  
  private lazy var musicArtist: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = musicItem.publisherTitle
    label.font = .preferredCustomFont(forTextStyle: .body, fontName: UIFont.RethinkSans.bold.rawValue)
    label.textColor = .secondaryLabel
    return label
  }()
  
  private lazy var progressBar: UIProgressView = {
    let progressBar = UIProgressView()
    progressBar.translatesAutoresizingMaskIntoConstraints = false
    progressBar.progressTintColor = .accent
    progressBar.progress = 0.3
    return progressBar
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
  
  private let previousMusicButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(
      UIImage(systemName: "backward.fill"),
      for: .normal
    )
    button.tintColor = .label
    return button
  }()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private let dismissButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "xmark")
    button.setImage(image, for: .normal)
    button.layer.cornerRadius = 15
    button.clipsToBounds = true
    button.tintColor = .darkGray
    button.configuration = .borderedTinted()
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(musicThumbnail)
    view.addSubview(musicTitle)
    view.addSubview(musicArtist)
    view.addSubview(progressBar)
    view.addSubview(stackView)
    view.addSubview(dismissButton)

    
    stackView.addArrangedSubview(previousMusicButton)
    stackView.addArrangedSubview(playPauseButton)
    stackView.addArrangedSubview(nextMusicButton)
    setupConstraints()
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      musicThumbnail.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      musicThumbnail.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
      musicThumbnail.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8),
      musicThumbnail.heightAnchor.constraint(equalTo: musicThumbnail.widthAnchor),
      
      musicTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      musicTitle.topAnchor.constraint(equalTo: musicThumbnail.bottomAnchor, constant: 10),
      
      musicArtist.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      musicArtist.topAnchor.constraint(equalTo: musicTitle.bottomAnchor, constant: 10),
      
      progressBar.topAnchor.constraint(equalTo: musicArtist.bottomAnchor, constant: 25),
      progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      progressBar.widthAnchor.constraint(equalTo: musicThumbnail.widthAnchor),
      
      stackView.widthAnchor.constraint(equalTo: musicThumbnail.widthAnchor),
      stackView.heightAnchor.constraint(equalToConstant: 40),
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10),
      
      dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
      dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
      dismissButton.widthAnchor.constraint(equalToConstant: 30),
      dismissButton.heightAnchor.constraint(equalToConstant: 30),
    ])
  }
}

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
    imageView.image = UIImage(systemName: "music.note")
    imageView.imageURL = URL(string: musicItem.largestThumbnail)
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = .accent.withAlphaComponent(0.1)
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
  
  private let addToPlaylistButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "music.note.list")
    button.setImage(image, for: .normal)
    button.layer.cornerRadius = 20
    button.clipsToBounds = true
    button.configuration = .borderedTinted()
    return button
  }()
  
  private let downloadMusicButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "arrow.down.circle")
    button.setImage(image, for: .normal)
    button.layer.cornerRadius = 20
    button.clipsToBounds = true
    button.configuration = .borderedTinted()
    return button
  }()
  
  private let nextMusicItemsButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "list.dash")
    button.setImage(image, for: .normal)
    button.layer.cornerRadius = 20
    button.clipsToBounds = true
    button.configuration = .borderedTinted()
    button.addTarget(
      self,
      action: #selector(handleNextMusicListTap),
      for: .touchUpInside
    )
    return button
  }()
  
  @objc func handleNextMusicListTap() {
    let nextSuggestedMusicListVC = NextSuggestedMusicItemsViewController()
    navigationController?.present(
      nextSuggestedMusicListVC,
      animated: true
    )
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(musicThumbnail)
    view.addSubview(musicTitle)
    view.addSubview(musicArtist)
    view.addSubview(progressBar)
    view.addSubview(stackView)
    view.addSubview(dismissButton)
    view.addSubview(addToPlaylistButton)
    view.addSubview(downloadMusicButton)
    view.addSubview(nextMusicItemsButton)

    
    stackView.addArrangedSubview(previousMusicButton)
    stackView.addArrangedSubview(playPauseButton)
    stackView.addArrangedSubview(nextMusicButton)
    setupConstraints()
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      musicThumbnail.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      musicThumbnail.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
      musicThumbnail.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
      musicThumbnail.heightAnchor.constraint(equalTo: musicThumbnail.widthAnchor),
      
      musicTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      musicTitle.topAnchor.constraint(equalTo: musicThumbnail.bottomAnchor, constant: 10),
      
      musicArtist.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      musicArtist.topAnchor.constraint(equalTo: musicTitle.bottomAnchor, constant: 10),
      
      progressBar.topAnchor.constraint(equalTo: musicArtist.bottomAnchor, constant: 25),
      progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      progressBar.widthAnchor.constraint(equalTo: musicThumbnail.widthAnchor),
      
      stackView.widthAnchor.constraint(equalTo: musicThumbnail.widthAnchor),
      stackView.heightAnchor.constraint(equalToConstant: 80),
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10),
      
      dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
      dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
      dismissButton.widthAnchor.constraint(equalToConstant: 30),
      dismissButton.heightAnchor.constraint(equalToConstant: 30),
      
      nextMusicItemsButton.trailingAnchor.constraint(equalTo: musicThumbnail.trailingAnchor),
      nextMusicItemsButton.bottomAnchor.constraint(equalTo: musicThumbnail.topAnchor, constant: -10),
      nextMusicItemsButton.widthAnchor.constraint(equalToConstant: 40),
      nextMusicItemsButton.heightAnchor.constraint(equalToConstant: 40),
      
      downloadMusicButton.heightAnchor.constraint(equalTo: nextMusicItemsButton.heightAnchor),
      downloadMusicButton.widthAnchor.constraint(equalTo: nextMusicItemsButton.widthAnchor),
      downloadMusicButton.trailingAnchor.constraint(equalTo: nextMusicItemsButton.leadingAnchor, constant: -10),
      downloadMusicButton.topAnchor.constraint(equalTo: nextMusicItemsButton.topAnchor),
      
      addToPlaylistButton.heightAnchor.constraint(equalTo: downloadMusicButton.heightAnchor),
      addToPlaylistButton.widthAnchor.constraint(equalTo: downloadMusicButton.widthAnchor),
      addToPlaylistButton.trailingAnchor.constraint(equalTo: downloadMusicButton.leadingAnchor, constant: -10),
      addToPlaylistButton.topAnchor.constraint(equalTo: downloadMusicButton.topAnchor),
    ])
  }
}

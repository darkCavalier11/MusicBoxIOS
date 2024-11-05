//
//  MusicPlayingDetailsViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 29/10/24.
//

import UIKit
import MusicBox
import RxSwift
import Swinject

class MusicPlayingDetailsViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let playingViewModel = Container.sharedContainer.resolve(PlayingViewModel.self)!
  private let browsingViewModel = Container.sharedContainer.resolve(BrowsingViewModel.self)!
  private var selectedMusicItem: MusicItem? = nil
  
  private lazy var musicThumbnail: UIAsyncImageView = {
    let imageView = UIAsyncImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(systemName: "music.note")
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = .accent.withAlphaComponent(0.1)
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 12
    return imageView
  }()
  
  private lazy var musicTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredCustomFont(forTextStyle: .title3, fontName: UIFont.RethinkSans.bold.rawValue)
    label.textColor = .label
    label.numberOfLines = 2
    return label
  }()
  
  private lazy var musicArtist: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
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
    button.addTarget(self, action: #selector(handleDismismissVC), for: .touchUpInside)
    return button
  }()
  
  @objc func handleDismismissVC() {
    self.dismiss(animated: true)
  }
  
  private let addToPlaylistButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(systemName: "music.note.list")
    button.setImage(image, for: .normal)
    button.layer.cornerRadius = 20
    button.clipsToBounds = true
    button.configuration = .borderedTinted()
    button.addTarget(self, action: #selector(handleAddToPlaylist), for: .touchUpInside)
    return button
  }()
  
  @objc func handleAddToPlaylist() {
    guard let selectedMusicItem else { return }
    browsingViewModel.addMusicToPlaylist(controller: self, musicItem: selectedMusicItem)
  }
  
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
    self.present(
      nextSuggestedMusicListVC,
      animated: true
    )
  }
  
  private func bindWithViewModel() {
    playingViewModel
      .selectedMusicItem
      .observe(on: MainScheduler.instance)
      .bind { [weak self] musicItem in
        guard let musicItem else { return }
        self?.selectedMusicItem = musicItem
        self?.musicTitle.text = musicItem.title
        self?.musicArtist.text = musicItem.publisherTitle
        // TODO: - Get sharp images
        self?.musicThumbnail.imageURL = URL(string: musicItem.largestThumbnail)
      }
      .disposed(by: disposeBag)
    
    playingViewModel
      .musicPlayingStatus
      .observe(on: MainScheduler.instance)
      .bind { [weak self] status in
        switch status {
        case .unknown, .error, .readyToPlay:
          self?.playPauseButton.isEnabled = false
          self?.previousMusicButton.isEnabled = false
          self?.nextMusicButton.isEnabled = false
        case .paused:
          self?.playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        case .playing:
          self?.playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        
        }
      }
      .disposed(by: disposeBag)
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
    view.backgroundColor = .systemBackground
    
    stackView.addArrangedSubview(previousMusicButton)
    stackView.addArrangedSubview(playPauseButton)
    stackView.addArrangedSubview(nextMusicButton)
    setupConstraints()
    bindWithViewModel()
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      musicThumbnail.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      musicThumbnail.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
      musicThumbnail.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
      musicThumbnail.heightAnchor.constraint(equalTo: musicThumbnail.widthAnchor),
      
      musicTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      musicTitle.topAnchor.constraint(equalTo: musicThumbnail.bottomAnchor, constant: 10),
      musicTitle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
      
      musicArtist.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      musicArtist.topAnchor.constraint(equalTo: musicTitle.bottomAnchor, constant: 10),
      musicArtist.widthAnchor.constraint(equalTo: musicTitle.widthAnchor),
      
      progressBar.topAnchor.constraint(equalTo: musicArtist.bottomAnchor, constant: 25),
      progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      progressBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
      
      stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
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

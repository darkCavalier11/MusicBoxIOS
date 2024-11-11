//
//  PlaylistTableView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 24/10/24.
//

import UIKit

class PlaylistTableView: UITableView {
  static let reusableIdentifier: String = "PlaylistTableViewCell"
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    register(PlaylistTableViewCell.self, forCellReuseIdentifier: Self.reusableIdentifier)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.rowHeight = 120
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class PlaylistTableViewCell: UITableViewCell {
  private let playPlaylistButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "play.circle"), for: .normal)
    return button
  }()
  
  private let centerImageView: UIAsyncImageView = {
    let imageView = UIAsyncImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 8
    imageView.layer.shadowColor = CGColor.init(red: 1.0, green: 0, blue: 0, alpha: 1)
    imageView.layer.shadowOpacity = 0.5
    return imageView
  }()
  
  private let rightImageView: UIAsyncImageView = {
    let imageView = UIAsyncImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.transform = CGAffineTransform(translationX: 20, y: 0).rotated(by: Double.pi / 15)
    imageView.layer.cornerRadius = 8
    return imageView
  }()
  
  private let leftImageView: UIAsyncImageView = {
    let imageView = UIAsyncImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.transform = CGAffineTransform(translationX: -20, y: 0).rotated(by: -Double.pi / 15)
    imageView.layer.cornerRadius = 8
    return imageView
  }()
  
  private let playlistTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Your playlist"
    label.numberOfLines = 2
    label.font = .preferredCustomFont(forTextStyle: .headline)
    return label
  }()
  
  private let durationTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredCustomFont(forTextStyle: .caption1, weight: .bold)
    return label
  }()
  
  private let artistDesc: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredCustomFont(forTextStyle: .caption1)
    label.numberOfLines = 2
    label.textColor = .secondaryLabel
    return label
  }()
  
  private let totalTrackLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredCustomFont(forTextStyle: .caption1, weight: .bold)
    return label
  }()
  
  var musicPlaylistModel: MusicPlaylistModel? {
    didSet {
      guard let musicPlaylistModel = musicPlaylistModel else { return }
      let images = musicPlaylistModel.top3ThumbnailURLs
      playlistTitle.text = musicPlaylistModel.title
      durationTitle.text = "Total Duration: " + musicPlaylistModel.totalDurationInSeconds.convertToDuration()
      centerImageView.image = nil
      leftImageView.image = nil
      rightImageView.image = nil
      if images.count >= 1 {
        centerImageView.imageURL = images[0]
      }
      if images.count >= 2 {
        leftImageView.imageURL = images[1]
      }
      if images.count >= 3 {
        rightImageView.imageURL = images[2]
      }
      artistDesc.text = musicPlaylistModel.artistDesc
      totalTrackLabel.text = "\(musicPlaylistModel.musicItems?.count ?? 0) Tracks"
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    let containerView = UIView()
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(containerView)
    
    containerView.addSubview(rightImageView)
    containerView.addSubview(leftImageView)
    containerView.addSubview(centerImageView)
    containerView.addSubview(playlistTitle)
    containerView.addSubview(durationTitle)
    containerView.addSubview(artistDesc)
    containerView.addSubview(totalTrackLabel)
    containerView.addSubview(playPlaylistButton)
    
    
    NSLayoutConstraint.activate([
      centerImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      centerImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      centerImageView.widthAnchor.constraint(equalToConstant: 75),
      centerImageView.heightAnchor.constraint(equalToConstant: 75),
      
      rightImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      rightImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      rightImageView.widthAnchor.constraint(equalToConstant: 75),
      rightImageView.heightAnchor.constraint(equalToConstant: 75),
      
      leftImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      leftImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      leftImageView.widthAnchor.constraint(equalToConstant: 75),
      leftImageView.heightAnchor.constraint(equalToConstant: 75),
      
      containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
      containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
      containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      playlistTitle.topAnchor.constraint(equalTo: centerImageView.topAnchor),
      playlistTitle.leadingAnchor.constraint(equalTo: centerImageView.trailingAnchor, constant: 50),
      playlistTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      
      durationTitle.topAnchor.constraint(equalTo: playlistTitle.bottomAnchor),
      durationTitle.leadingAnchor.constraint(equalTo: centerImageView.trailingAnchor, constant: 50),
      durationTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      
      artistDesc.topAnchor.constraint(equalTo: durationTitle.bottomAnchor),
      artistDesc.leadingAnchor.constraint(equalTo: centerImageView.trailingAnchor, constant: 50),
      artistDesc.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      
      totalTrackLabel.topAnchor.constraint(equalTo: artistDesc.bottomAnchor),
      totalTrackLabel.leadingAnchor.constraint(equalTo: centerImageView.trailingAnchor, constant: 50),
      
      playPlaylistButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      playPlaylistButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 10),
      playPlaylistButton.widthAnchor.constraint(equalToConstant: 30),
      playPlaylistButton.heightAnchor.constraint(equalToConstant: 30),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

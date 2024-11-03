//
//  RecentlyPlayedMusicItemCollectionView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 03/11/24.
//

import UIKit
import MusicBox

class RecentlyPlayedMusicCollectionView: UICollectionView {
  static let reusableIdentifier = "RecentlyPlayedMusicItemCollectionViewCell"
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    self.register(
      RecentlyPlayedMusicItemCollectionViewCell.self,
      forCellWithReuseIdentifier: Self.reusableIdentifier
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class RecentlyPlayedMusicItemCollectionViewCell: UICollectionViewCell {
  var musicItem: MusicItem = MusicItem(
    title: "ଲାଲ୍ ଟହ ଟହ dei golapa kalu",
    publisherTitle: "Amara Muzik Odia",
    runningDurationInSeconds: 278,
    musicId: "ZV-ENArlmsI",
    smallestThumbnail: "https://i.ytimg.com/vi/ZV-ENArlmsI/hq720.jpg?sqp=-oaymwEjCOgCEMoBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLDAfhoBYKPYo87qqkJorTByGqA0HA",
    largestThumbnail: "https://i.ytimg.com/vi/ZV-ENArlmsI/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLD9moLVewt2KG1RgfkHnLub2Atybw"
  )
  
  private lazy var imageView: UIAsyncImageView = {
    let imageView = UIAsyncImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.imageURL = URL(string: musicItem.largestThumbnail)
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 8
    return imageView
  }()
  
  private lazy var titleLabel: UILabel = {
    let title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.text = musicItem.title
    title.font = .preferredCustomFont(forTextStyle: .body)
    return title
  }()

  private lazy var subTitleLabel: UILabel = {
    let title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.text = musicItem.publisherTitle
    title.font = .preferredCustomFont(forTextStyle: .caption1)
    title.textColor = .secondaryLabel
    return title
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(subTitleLabel)
    setupConstraints()
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
      imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      
      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
      titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
      
      subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
      subTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
      subTitleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

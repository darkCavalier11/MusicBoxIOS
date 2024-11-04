//
//  DownloadTableView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 04/11/24.
//

import UIKit
import MusicBox
import RxSwift
import RxCocoa

class DownloadTableView: UITableView {
  static let reusableIdentifier: String = "DownloadTableViewCell"
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    self.register(DownloadTableViewCell.self, forCellReuseIdentifier: Self.reusableIdentifier)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.rowHeight = 110
    self.separatorStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class DownloadTableViewCell: UITableViewCell {
  private let disposeBag = DisposeBag()
  
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
  
  private let title: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 2
    label.font = .preferredCustomFont(forTextStyle: .headline)
    return label
  }()
  
  private let durationTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredCustomFont(forTextStyle: .caption1, weight: .bold)
    label.textColor = .secondaryLabel
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
  
  
  var musicItemModel: MusicItemModel? {
    didSet {
      guard let musicItemModel = musicItemModel else { return }
      title.text = musicItemModel.title
      durationTitle.text = "\(Int(musicItemModel.runningDurationInSeconds).convertToDuration())"
      centerImageView.imageURL = URL(
        string: musicItemModel.smallestThumbnail ?? MusicItem.defaultSmallestThumbnail
      )
      artistDesc.text = musicItemModel.publisherTitle
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.layer.cornerRadius = 24
    let containerView = UIView()
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(containerView)
    containerView.addSubview(centerImageView)
    containerView.addSubview(title)
    containerView.addSubview(durationTitle)
    containerView.addSubview(artistDesc)
    
    
    NSLayoutConstraint.activate([
      centerImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      centerImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      centerImageView.widthAnchor.constraint(equalToConstant: 75),
      centerImageView.heightAnchor.constraint(equalToConstant: 75),
      
      containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
      containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
      containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      title.topAnchor.constraint(equalTo: centerImageView.topAnchor),
      title.leadingAnchor.constraint(equalTo: centerImageView.trailingAnchor, constant: 10),
      title.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      
      durationTitle.topAnchor.constraint(equalTo: artistDesc.bottomAnchor),
      durationTitle.leadingAnchor.constraint(equalTo: centerImageView.trailingAnchor, constant: 10),
      durationTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      
      artistDesc.topAnchor.constraint(equalTo: title.bottomAnchor),
      artistDesc.leadingAnchor.constraint(equalTo: centerImageView.trailingAnchor, constant: 10),
      artistDesc.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
    ])
  }
  
  func bindWithViewModel(viewModel: DownloadViewModel) {
    viewModel
    .playingViewModel
    .selectedMusicItem
    .observe(on: MainScheduler.instance)
    .bind { [weak self] musicItem in
      if musicItem?.musicId == self?.musicItemModel?.musicId {
        self?.backgroundColor = UIColor.accent.withAlphaComponent(0.1)
        self?.title.textColor = .accent
      } else {
        self?.backgroundColor = .none
        self?.title.textColor = nil
      }
    }
    .disposed(by: disposeBag)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

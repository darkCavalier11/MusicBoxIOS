//
//  InProgressDownloadTableView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 04/11/24.
//

import UIKit
import MusicBox
import RxSwift
import SwiftUI

class InProgressDownloadTableView: UITableView {
  static let reusableIdentifier = "InProgressDownloadTableViewCell"
  private let disposeBag = DisposeBag()
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.separatorStyle = .none
    register(InProgressDownloadTableViewCell.self, forCellReuseIdentifier: Self.reusableIdentifier)
    self.rowHeight = 110
  }
  
  func bindWithViewModel(viewModel: DownloadViewModel) {
    viewModel
      .inProgressDownlods
      .bind(
        to:
          self.rx.items(
            cellIdentifier: Self.reusableIdentifier,
            cellType: InProgressDownloadTableViewCell.self
          )
      ) { row, musicDownloadItem, cell in
        cell.musicDownloadItem = musicDownloadItem
      }
      .disposed(by: disposeBag)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class InProgressDownloadTableViewCell: UITableViewCell {
  var musicDownloadItem: MusicDownloadItem? {
    didSet {
      guard let musicItem = musicDownloadItem?.musicItem else { return }
      musicTitle.text = musicItem.title
      musicArtistTitle.text = musicItem.publisherTitle
      musicDuration.text = musicItem.runningDurationInSeconds.convertToDuration()
      
      DispatchQueue.global().async { [weak self] in
        guard let url = URL(string: musicItem.smallestThumbnail) else { return }
        guard let imageData = try? Data(contentsOf: url) else { return }
        DispatchQueue.main.async {
          let image = UIImage(data: imageData)
          self?.musicThumbnail.image = image
        }
      }
      
      guard let fractionDownloaded = musicDownloadItem?.fractionDownloaded else { return }
      fractionDownloaded
        .observe(on: MainScheduler.instance)
        .bind { [weak self] progress in
          self?.circularProgressView.setProgres(progress, animated: false)
        }
        .disposed(by: disposeBag)
    }
  }
  
  private let circularProgressView = CircularProgressView()
  
  private let thumbnailMask: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .black.withAlphaComponent(0.8)
    view.layer.cornerRadius = 6
    return view
  }()
  
  private var musicThumbnail: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 6
    return imageView
  }()
  
  private lazy var musicTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 2
    label.font = .preferredCustomFont(forTextStyle: .body)
    return label
  }()
  
  private lazy var musicArtistTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredCustomFont(forTextStyle: .caption2)
    label.numberOfLines = 1
    label.textColor = .secondaryLabel
    return label
  }()
  
  private lazy var musicDuration: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredCustomFont(forTextStyle: .caption1)
    label.textColor = .secondaryLabel
    return label
  }()
  
  private lazy var musicCellContainer = UIView()
  private let disposeBag = DisposeBag()
  let textStackView: UIStackView = {
    let textStackView = UIStackView()
    textStackView.axis = .vertical
    textStackView.spacing = 4
    textStackView.alignment = .leading
    textStackView.translatesAutoresizingMaskIntoConstraints = false
    return textStackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    textStackView.addArrangedSubview(musicTitle)
    textStackView.addArrangedSubview(musicArtistTitle)
    textStackView.addArrangedSubview(musicDuration)
    
    musicThumbnail.addSubview(thumbnailMask)
    thumbnailMask.addSubview(circularProgressView)
    circularProgressView.translatesAutoresizingMaskIntoConstraints = false
    musicCellContainer.translatesAutoresizingMaskIntoConstraints = false
    musicCellContainer.addSubview(textStackView)
    musicCellContainer.addSubview(musicThumbnail)
    contentView.addSubview(musicCellContainer)
    setupConstraints()
  }
  
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      musicCellContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
      musicCellContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      musicCellContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
      musicCellContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      
      musicThumbnail.centerYAnchor.constraint(equalTo: musicCellContainer.centerYAnchor),
      musicThumbnail.leadingAnchor.constraint(equalTo: musicCellContainer.leadingAnchor),
      musicThumbnail.heightAnchor.constraint(equalToConstant: 80),
      musicThumbnail.widthAnchor.constraint(equalToConstant: 80),
      
      thumbnailMask.leadingAnchor.constraint(equalTo: musicThumbnail.leadingAnchor),
      thumbnailMask.trailingAnchor.constraint(equalTo: musicThumbnail.trailingAnchor),
      thumbnailMask.topAnchor.constraint(equalTo: musicThumbnail.topAnchor),
      thumbnailMask.bottomAnchor.constraint(equalTo: musicThumbnail.bottomAnchor),
      
      circularProgressView.centerXAnchor.constraint(equalTo: thumbnailMask.centerXAnchor),
      circularProgressView.centerYAnchor.constraint(equalTo: thumbnailMask.centerYAnchor),
      circularProgressView.widthAnchor.constraint(equalToConstant: 15),
      circularProgressView.heightAnchor.constraint(equalToConstant: 15),
      
      textStackView.leadingAnchor.constraint(equalTo: musicThumbnail.trailingAnchor, constant: 10),
      textStackView.trailingAnchor.constraint(equalTo: musicCellContainer.trailingAnchor),
      textStackView.centerYAnchor.constraint(equalTo: musicCellContainer.centerYAnchor),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

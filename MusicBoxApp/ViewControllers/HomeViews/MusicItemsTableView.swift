//
//  MusicItemsTableView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 21/10/24.
//

import UIKit
import MusicBox

class MusicItemsTableView: UITableView {
  static let reusableIdentifier = "MusicItemTableViewCell"
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    register(MusicItemTableViewCell.self, forCellReuseIdentifier: Self.reusableIdentifier)
    self.rowHeight = 80
    self.separatorStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class MusicItemTableViewCell: UITableViewCell {
  private var musicThumbnail: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private var musicTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 1
    label.font = .preferredFont(forTextStyle: .headline)
    return label
  }()
  
  private var musicPublisherTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .caption2)
    label.numberOfLines = 1
    label.textColor = .secondaryLabel
    return label
  }()
  
  private var musicDuration: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .footnote)
    label.textColor = .secondaryLabel
    return label
  }()
  
  var musicItem: MusicItem?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    let musicCellContainer = UIView()
    musicCellContainer.translatesAutoresizingMaskIntoConstraints = false
    
    guard let musicItem = musicItem else { return }
    musicTitle.text = musicItem.title
    musicPublisherTitle.text = musicItem.publisherTitle
    musicDuration.text = musicItem.runningDurationInSeconds.convertToDuration()
    
    DispatchQueue.global().async { [weak self] in
      guard let url = URL(string: musicItem.smallestThumbnail) else { return }
      guard let imageData = try? Data(contentsOf: url) else { return }
      self?.musicThumbnail.image = UIImage(data: imageData)
    }
    
    musicCellContainer.addSubview(musicThumbnail)
    musicCellContainer.addSubview(musicTitle)
    musicCellContainer.addSubview(musicPublisherTitle)
    musicCellContainer.addSubview(musicDuration)
    contentView.addSubview(musicCellContainer)
    
    NSLayoutConstraint.activate([
      musicCellContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      musicCellContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      musicCellContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor),
      musicCellContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16),
      
      musicThumbnail.centerYAnchor.constraint(equalTo: musicCellContainer.centerYAnchor),
      musicThumbnail.leadingAnchor.constraint(equalTo: musicCellContainer.leadingAnchor),
      musicThumbnail.heightAnchor.constraint(equalTo: musicCellContainer.heightAnchor, constant: -10),
      musicThumbnail.widthAnchor.constraint(equalTo: musicCellContainer.heightAnchor, constant: -10),
      
      musicTitle.leadingAnchor.constraint(equalTo: musicThumbnail.trailingAnchor, constant: 10),
      musicTitle.topAnchor.constraint(equalTo: musicThumbnail.topAnchor),
      musicTitle.trailingAnchor.constraint(equalTo: musicCellContainer.trailingAnchor),
      
      musicPublisherTitle.leadingAnchor.constraint(equalTo: musicTitle.leadingAnchor),
      musicPublisherTitle.topAnchor.constraint(equalTo: musicTitle.bottomAnchor, constant: 5),
      musicPublisherTitle.trailingAnchor.constraint(equalTo: musicCellContainer.trailingAnchor),
      
      musicDuration.leadingAnchor.constraint(equalTo: musicTitle.leadingAnchor),
      musicDuration.topAnchor.constraint(equalTo: musicPublisherTitle.bottomAnchor, constant: 5),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension Int {
  func convertToDuration() -> String {
    var duration = self
    let seconds = duration % 60
    duration /= 60
    let minutes = duration % 60
    duration /= 60
    let hours = duration
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
  }
}

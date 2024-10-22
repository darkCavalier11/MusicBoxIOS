//
//  MusicItemsTableView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 21/10/24.
//

import UIKit
import MusicBox
import RxSwift

class MusicItemsTableView: UITableView {
  static let reusableIdentifier = "MusicItemTableViewCell"
  private let disposeBag = DisposeBag()
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    register(MusicItemTableViewCell.self, forCellReuseIdentifier: Self.reusableIdentifier)
    self.rowHeight = 100
    self.separatorStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bindWithViewModel(viewModel: MusicViewModel) {
    self.dataSource = nil
    self.delegate = nil
    
    viewModel
      .getMusicList(query: .withSearchQuery(query: "Mahua pani"))
      .subscribe(on: MainScheduler.instance)
      .bind(
        to: self.rx.items(
          cellIdentifier: MusicItemsTableView.reusableIdentifier,
          cellType: MusicItemTableViewCell.self
        )
      ) { row, musicItem, cell in
        cell.musicItem = musicItem
      }
      .disposed(by: disposeBag)
  }
}

class MusicItemTableViewCell: UITableViewCell {
  private var musicThumbnail: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
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
  
  var musicItem: MusicItem? {
    didSet {
      guard let musicItem = musicItem else { return }
      musicTitle.text = musicItem.title
      musicPublisherTitle.text = musicItem.publisherTitle
      musicDuration.text = musicItem.runningDurationInSeconds.convertToDuration()

      DispatchQueue.global().async { [weak self] in
        guard let url = URL(string: musicItem.smallestThumbnail) else { return }
        guard let imageData = try? Data(contentsOf: url) else { return }
        DispatchQueue.main.async {
          let image = UIImage(data: imageData)
          self?.musicThumbnail.image = UIImage(data: imageData)
        }
      }
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    let musicCellContainer = UIView()
    musicCellContainer.translatesAutoresizingMaskIntoConstraints = false
    

    musicCellContainer.addSubview(musicTitle)
    musicCellContainer.addSubview(musicPublisherTitle)
    musicCellContainer.addSubview(musicDuration)
    musicCellContainer.addSubview(musicThumbnail)
    contentView.addSubview(musicCellContainer)
    
    NSLayoutConstraint.activate([
      musicCellContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      musicCellContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      musicCellContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
      musicCellContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      
      musicThumbnail.centerYAnchor.constraint(equalTo: musicCellContainer.centerYAnchor),
      musicThumbnail.leadingAnchor.constraint(equalTo: musicCellContainer.leadingAnchor),
      musicThumbnail.heightAnchor.constraint(equalToConstant: 70),
      musicThumbnail.widthAnchor.constraint(equalToConstant: 70),
      
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

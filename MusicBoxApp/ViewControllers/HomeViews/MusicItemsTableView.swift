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
    self.rowHeight = 110
    self.separatorStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bindWithViewModel(viewModel: MusicViewModel) {
    self.dataSource = nil
    self.delegate = nil
    
    viewModel
      .musicItemList
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

protocol MusicItemTableViewCellDelegate: AnyObject {
  func navigateToAddToPlaylistScreen(for musicItem: MusicItem)
  func addToFavorite(for musicItem: MusicItem)
  func startDownload(for musicItem: MusicItem)
}

class MusicItemTableViewCell: UITableViewCell {
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
    label.font = .preferredCustomFont(forTextStyle: .callout)
    return label
  }()
  
  private lazy var musicPublisherTitle: UILabel = {
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
  
  private var menuButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.tintColor = .secondaryLabel
    button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    button.menu = UIMenu(
      title: "More",
      children: [
        UIAction(
          title: "Add to Favourites",
          image: UIImage(systemName: "heart")
        ) { _ in
          
        },
        UIAction(
          title: "Add to playlist",
          image: UIImage(systemName: "music.note.list")
        ) { _ in
          
        },
        UIAction(
          title: "Download",
          image: UIImage(systemName: "arrow.down.circle")
        ) { _ in
          
        },
      ]
    )
    button.showsMenuAsPrimaryAction = true
    return button
  }()
  
  weak var delegate: MusicItemTableViewCellDelegate?
  
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
          self?.musicThumbnail.image = image
        }
      }
    }
  }
    
  private lazy var musicCellContainer = UIView()
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
    textStackView.addArrangedSubview(musicPublisherTitle)
    textStackView.addArrangedSubview(musicDuration)
    
    musicCellContainer.translatesAutoresizingMaskIntoConstraints = false
    musicCellContainer.addSubview(textStackView)
    musicCellContainer.addSubview(musicThumbnail)
    musicCellContainer.addSubview(menuButton)
    contentView.addSubview(musicCellContainer)
  }
  
  func setupButtonMenuItems() {
    let menu = UIMenu(
      children: [
        UIAction(title: "Add to Favourite") { [weak self] _ in
          guard let musicItem = self?.musicItem else { return }
          self?.delegate?.addToFavorite(for: musicItem)
        },
        UIAction(title: "Add to Playlist") { [weak self] _ in
          guard let musicItem = self?.musicItem else { return }
          self?.delegate?.navigateToAddToPlaylistScreen(for: musicItem)
        },
        UIAction(title: "Start Download") { [weak self] _ in
          guard let musicItem = self?.musicItem else { return }
          self?.delegate?.startDownload(for: musicItem)
        }
      ]
    )
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      musicCellContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -16),
      musicCellContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      musicCellContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
      musicCellContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      
      musicThumbnail.centerYAnchor.constraint(equalTo: musicCellContainer.centerYAnchor),
      musicThumbnail.leadingAnchor.constraint(equalTo: musicCellContainer.leadingAnchor),
      musicThumbnail.heightAnchor.constraint(equalToConstant: 80),
      musicThumbnail.widthAnchor.constraint(equalToConstant: 80),
      
      menuButton.trailingAnchor.constraint(equalTo: musicCellContainer.trailingAnchor),
      menuButton.centerYAnchor.constraint(equalTo: musicCellContainer.centerYAnchor),
      
      textStackView.leadingAnchor.constraint(equalTo: musicThumbnail.trailingAnchor, constant: 10),
      textStackView.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor),
      textStackView.centerYAnchor.constraint(equalTo: musicCellContainer.centerYAnchor),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

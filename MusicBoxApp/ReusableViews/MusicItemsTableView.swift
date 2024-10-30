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
  
  weak var actionDelegate: MusicItemTableViewActionDelegate?
  
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    register(MusicItemTableViewCell.self, forCellReuseIdentifier: Self.reusableIdentifier)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.rowHeight = 110
    self.separatorStyle = .none
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bindWithViewModel(viewModel: BrowsingViewModel) {
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
        let menu = UIMenu(
          children: [
            UIAction(title: "Add to Playlist", image: UIImage(systemName: "music.note.list")) { [weak self] _ in
              self?.actionDelegate?.navigateToAddToPlaylistScreen(for: musicItem)
            },
            UIAction(title: "Start Download", image: UIImage(systemName: "arrow.down.circle")) { [weak self] _ in
              self?.actionDelegate?.startDownload(for: musicItem)
            }
          ]
        )
        cell.menuButton.menu = menu
        cell.musicItem = musicItem
        cell.selectionStyle = .none
        cell.bindWithViewModel(viewModel: viewModel.playingViewModel)
      }
      .disposed(by: disposeBag)
    
    self
      .rx
      .itemSelected
      .subscribe(on: MainScheduler.instance)
      .bind { indexPath in
        guard let cell = self.cellForRow(at: indexPath) as? MusicItemTableViewCell,
        let musicItem = cell.musicItem else {
          return
        }
        viewModel.playingViewModel.playMusicItem(musicItem: musicItem)
      }
      .disposed(by: disposeBag)
  }
}

protocol MusicItemTableViewActionDelegate: AnyObject {
  func navigateToAddToPlaylistScreen(for musicItem: MusicItem)
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
  
  var menuButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.tintColor = .secondaryLabel
    button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    button.showsMenuAsPrimaryAction = true
    return button
  }()
  
  var musicItem: MusicItem? {
    didSet {
      guard let musicItem = musicItem else { return }
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
    }
  }
    
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
    
    musicCellContainer.translatesAutoresizingMaskIntoConstraints = false
    musicCellContainer.addSubview(textStackView)
    musicCellContainer.addSubview(musicThumbnail)
    musicCellContainer.addSubview(menuButton)
    contentView.addSubview(musicCellContainer)
    setupConstraints()
    self.layer.cornerRadius = 24
    
  }
  
  func bindWithViewModel(viewModel: PlayingViewModel) {
    viewModel
      .selectedMusicItem
      .subscribe(on: MainScheduler.instance)
      .bind { [weak self] musicItem in
        if musicItem?.musicId == self?.musicItem?.musicId {
          self?.backgroundColor = .accent.withAlphaComponent(0.1)
          self?.musicTitle.textColor = .accent
        } else {
          self?.musicTitle.textColor = nil
          self?.backgroundColor = nil
        }
      }
      .disposed(by: disposeBag)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      musicCellContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -36),
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

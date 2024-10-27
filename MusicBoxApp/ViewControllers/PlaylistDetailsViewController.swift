//
//  PlaylistDetailsViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 27/10/24.
//

import UIKit
import MusicBox
import RxSwift

class PlaylistDetailsViewController: UIViewController {
  private let viewModel = MusicListViewModel()
  
  weak var musicPlaylistModel: MusicPlaylistModel? {
    didSet {
      guard let musicPlaylistModel, let id = musicPlaylistModel.id else { return }
      viewModel.setMusicListQuery(.playlist(id: id))
      title = musicPlaylistModel.title
    }
  }
  
  weak var playlistService: MusicPlaylistServices?
  
  private let musicItemsTableView = MusicItemsTableView()
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(musicItemsTableView)
    musicItemsTableView.bindWithViewModel(viewModel: viewModel)
    musicItemsTableView.actionDelegate = self
    setupMusicItemsTableViewConstraints()
    
    musicItemsTableView
      .rx
      .itemDeleted
      .bind { [weak self] indexPath in
        guard let self else { return }
        guard let musicPlaylistModel = self.musicPlaylistModel else { return }
        self.viewModel.dismissMusicItem(
          musicPlaylistModel: musicPlaylistModel,
          index: indexPath.row
        ) { [weak self] in
          guard let id = self?.musicPlaylistModel?.id else { return }
          self?
            .viewModel
            .setMusicListQuery(.playlist(id: id))
        }
      }
      .disposed(by: disposeBag)
  }
  
  func setupMusicItemsTableViewConstraints() {
    musicItemsTableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: musicItemsTableView.topAnchor),
      view.leadingAnchor.constraint(equalTo: musicItemsTableView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: musicItemsTableView.trailingAnchor),
      view.bottomAnchor.constraint(equalTo: musicItemsTableView.bottomAnchor),
    ])
  }
}

extension PlaylistDetailsViewController: MusicItemTableViewActionDelegate {
  func navigateToAddToPlaylistScreen(for musicItem: MusicItem) {
    guard let navigationController else { return }
    viewModel.addMusicToPlaylist(controller: navigationController, musicItem: musicItem)
  }
  
  func startDownload(for musicItem: MusicItem) {
    
  }
}

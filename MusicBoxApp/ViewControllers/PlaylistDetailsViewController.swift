//
//  PlaylistDetailsViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 27/10/24.
//

import UIKit
import MusicBox
import RxSwift
import Swinject

class PlaylistDetailsViewController: UIViewController {
  private let viewModel = Container.sharedContainer.resolve(BrowsingViewModel.self)!
  
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

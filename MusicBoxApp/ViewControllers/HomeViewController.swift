//
//  HomeViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit
import RxSwift
import MusicBox
import Swinject

class HomeViewController: UIViewController {
  private let homeMusicViewModel = Container.sharedContainer.resolve(BrowsingViewModel.self)!
  private let disposeBag = DisposeBag()
  private let musicItemsTableView = MusicItemsTableView()
  override func viewDidLoad() {
    super.viewDidLoad()
    musicItemsTableView.actionDelegate = self
    view.addSubview(musicItemsTableView)
    setupMusicItemsTableViewConstraints()
    navigationItem.title = "Welcome"
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(
        image: UIImage(systemName: "magnifyingglass"),
        style: .plain,
        target: self,
        action: #selector(navigateToSearchViewController)
      )
    ]
    musicItemsTableView.bindWithViewModel(
      viewModel: homeMusicViewModel
    )
    homeMusicViewModel
      .setMusicListQuery(.withSearchQuery(query: "Ed sheeran"))
  }
  
  @objc func navigateToSearchViewController() {
    let searchViewController = SearchViewController()
    navigationController?.pushViewController(searchViewController, animated: true)
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

extension UIViewController: MusicItemTableViewActionDelegate {
  func navigateToAddToPlaylistScreen(for musicItem: MusicItem) {
    let musicViewModel = Container.sharedContainer.resolve(BrowsingViewModel.self)!
    musicViewModel.addMusicToPlaylist(controller: self, musicItem: musicItem)
  }
  
  func startDownload(for musicItem: MusicItem) {
    // TODO: -
  }
}

extension MusicItem: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(musicId)
  }
  
}

//
//  MusicSearchResultViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 23/10/24.
//

import UIKit
import RxSwift

class MusicSearchResultViewController: UIViewController {
  weak var homeMusicViewModel: MusicViewModel? {
    didSet {
      if let homeMusicViewModel {
        musicItemsTableView.bindWithViewModel(viewModel: homeMusicViewModel)
      }
    }
  }
  
  private let disposeBag = DisposeBag()
  private let musicItemsTableView = MusicItemsTableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(musicItemsTableView)
    setupMusicItemsTableViewConstraints()
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

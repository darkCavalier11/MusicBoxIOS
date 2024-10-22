//
//  HomeViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
  private var musicSearchFieldController = MusicSearchFieldController()
  private let searchViewModel = HomeSearchViewModel()
  private let homeMusicViewModel = HomeMusicViewModel()
  let disposeBag = DisposeBag()
  private let musicSearchTypeAheadTableView = MusicSearchTypeAheadTableView()
  private let musicItemsTableView = MusicItemsTableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(musicItemsTableView)
    setupMusicItemsTableViewConstraints()
    
    navigationItem.title = "Welcome"
    navigationItem.searchController = musicSearchFieldController
    view.addSubview(musicSearchTypeAheadTableView)
    
    musicSearchTypeAheadTableView.bindWithViewModel(viewModel: searchViewModel)
    musicSearchFieldController.bindWithViewModel(viewModel: searchViewModel)
    musicItemsTableView.bindWithViewModel(viewModel: homeMusicViewModel)
    setupSearchScreenTableViewConstraints()
  }
  
  func setupSearchScreenTableViewConstraints() {
    musicSearchTypeAheadTableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: musicSearchTypeAheadTableView.topAnchor),
      view.leadingAnchor.constraint(equalTo: musicSearchTypeAheadTableView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: musicSearchTypeAheadTableView.trailingAnchor),
      view.bottomAnchor.constraint(equalTo: musicSearchTypeAheadTableView.bottomAnchor),
    ])
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


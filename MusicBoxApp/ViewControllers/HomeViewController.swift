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
  private let viewModel = HomeSearchViewModel()
  let disposeBag = DisposeBag()
  private let musicSearchTypeAheadTableView = MusicSearchTypeAheadTableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Welcome"
    navigationItem.searchController = musicSearchFieldController
    view.addSubview(musicSearchTypeAheadTableView)
    
    musicSearchTypeAheadTableView.bindWithViewModel(viewModel: viewModel)
    musicSearchFieldController.bindWithViewModel(viewModel: viewModel)
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
}

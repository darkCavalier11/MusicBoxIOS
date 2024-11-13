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
  private let noHomeScreenMusicFoundView = NoHomeScreenMusicFoundView()
  override func viewDidLoad() {
    super.viewDidLoad()
    musicItemsTableView.actionDelegate = self
    view.addSubview(musicItemsTableView)
    view.addSubview(noHomeScreenMusicFoundView)
    noHomeScreenMusicFoundView.isHidden = true
    
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
      .setMusicListQuery(.defaultMusicList)
    
    Observable.combineLatest(
      homeMusicViewModel.musicItemList.map { $0.isEmpty },
      homeMusicViewModel.isFetchingMusicList
    )
      .observe(on: MainScheduler.instance)
      .bind { [weak self] (isEmpty, isFetching) in
        print(isFetching)
        self?.noHomeScreenMusicFoundView.isHidden = (isFetching || !isEmpty)
      }
      .disposed(by: disposeBag)
      
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
      
      noHomeScreenMusicFoundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      noHomeScreenMusicFoundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      noHomeScreenMusicFoundView.widthAnchor.constraint(equalToConstant: 250),
    ])
  }
}


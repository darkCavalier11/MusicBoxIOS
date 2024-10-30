//
//  NextSuggestedMusicItemsViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 29/10/24.
//
import UIKit
import Swinject
import RxSwift

class NextSuggestedMusicItemsViewController: UIViewController {
  private let musicItemsTableView = MusicItemsTableView()
  private let musicViewModel = Container.sharedContainer.resolve(BrowsingViewModel.self)!
  private let disposeBag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.title = "Next Suggested Music"
    view.addSubview(musicItemsTableView)
    musicItemsTableView.bindWithViewModel(viewModel: musicViewModel)
    musicViewModel.playingViewModel.selectedMusicItem.observe(on: MainScheduler.instance)
      .bind { [weak self] musicItem in
        guard let musicItem else { return }
        self?.musicViewModel.setMusicListQuery(.withSearchQuery(query: "One Direction"))
      }
      .disposed(by: disposeBag)
    
    
    NSLayoutConstraint.activate([
      musicItemsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      musicItemsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      musicItemsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      musicItemsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    ])
  }
  
}

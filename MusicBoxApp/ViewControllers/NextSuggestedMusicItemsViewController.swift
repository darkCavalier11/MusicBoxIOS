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
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Next Suggested Music"
    label.font = .preferredCustomFont(forTextStyle: .title3, fontName: UIFont.RethinkSans.bold.rawValue)
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    view.addSubview(titleLabel)
    view.addSubview(musicItemsTableView)
    
    musicItemsTableView.actionDelegate = self
    musicItemsTableView.bindWithViewModel(viewModel: musicViewModel)
    musicViewModel.playingViewModel.selectedMusicItem.observe(on: MainScheduler.instance)
      .bind { [weak self] musicItem in
        guard let musicItem else { return }
        self?.musicViewModel
          .setMusicListQuery(
          .nextMusicItems(currentMusicId: musicItem.musicId)
          )
      }
      .disposed(by: disposeBag)
    
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      musicItemsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      musicItemsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      musicItemsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      musicItemsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
    ])
  }
  
}

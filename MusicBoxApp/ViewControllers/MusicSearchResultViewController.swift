//
//  MusicSearchResultViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 23/10/24.
//

import UIKit
import RxSwift
import MusicBox

class MusicSearchResultViewController: UIViewController {
  var query: MusicListQueryType? {
    didSet {
      if let query {
        searchResultViewModel.setMusicListQuery(query)
      }
    }
  }
  
  private let loadingView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "LoadingIllustration")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let searchResultViewModel = MusicBrowsingViewModel()
  var searchViewModel: SearchViewModel?
  
  private let disposeBag = DisposeBag()
  private let musicItemsTableView = MusicItemsTableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(musicItemsTableView)
    musicItemsTableView.bindWithViewModel(viewModel: searchResultViewModel)
    musicItemsTableView.actionDelegate = self
    view.addSubview(loadingView)
    
    switch query {
    case .withSearchQuery(let query):
      self.navigationItem.title = query
    default :
      break
    }
    
    searchResultViewModel
      .isFetchingMusicList
      .bind { [weak self] isLoading in
        DispatchQueue.main.async {
          self?.loadingView.isHidden = !isLoading
        }
      }
      .disposed(by: disposeBag)
    
    setupLoadingViewConstraints()
    setupMusicItemsTableViewConstraints()
    
    UIView.animate(
      withDuration: 0.8,
      delay: 0,
      options: [.repeat, .autoreverse]
    ) {
      self.loadingView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    } completion: { _ in
    }
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
  
  func setupLoadingViewConstraints() {
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
      view.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
      loadingView.widthAnchor.constraint(equalToConstant: 150),
      loadingView.heightAnchor.constraint(equalToConstant: 150),
    ])
  }
}

extension MusicSearchResultViewController: MusicItemTableViewActionDelegate {
  func navigateToAddToPlaylistScreen(for musicItem: MusicItem) {
    guard let navigationController else { return }
    searchResultViewModel.addMusicToPlaylist(controller: navigationController, musicItem: musicItem)
  }
  
  func startDownload(for musicItem: MusicItem) {
    // TODO: -
  }
}

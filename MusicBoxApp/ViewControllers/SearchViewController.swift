//
//  SearchViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 22/10/24.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {
  private let searchViewModel = HomeSearchViewModel()
  private let disposeBag = DisposeBag()
  private let musicSearchTypeAheadTableView = MusicSearchTypeAheadTableView()
  private let musicSearchBar = MusicSearchBar()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "chevron.left"),
      style: .plain,
      target: self,
      action: #selector(popViewController)
    )
    navigationItem.largeTitleDisplayMode = .never
    view.addSubview(musicSearchTypeAheadTableView)
    view.addSubview(musicSearchBar)
    musicSearchTypeAheadTableView.bindWithViewModel(viewModel: searchViewModel)
    
    musicSearchTypeAheadTableView
      .rx
      .modelSelected(String.self).bind { query in
        
    }
    .disposed(by: disposeBag)
    
    musicSearchBar
      .rx
      .searchButtonClicked
      .bind { [weak self] in
        guard let query = self?.musicSearchBar.text else { return }
      }
      .disposed(by: disposeBag)
    
    musicSearchBar.bindWithViewModel(viewModel: searchViewModel)
    setupSearchScreenTableViewConstraints()
  }
  
  @objc private func popViewController() {
    navigationController?.popViewController(animated: true)
  }
  
  private func navigateToMusicSearchResultVC(_ query: String) {
    let musicSearchResultVC = MusicSearchResultViewController()
    navigationController?.pushViewController(musicSearchResultVC, animated: true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    musicSearchBar.becomeFirstResponder()
  }
  
  func setupSearchScreenTableViewConstraints() {
    musicSearchTypeAheadTableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      musicSearchBar.bottomAnchor.constraint(equalTo: musicSearchTypeAheadTableView.topAnchor),
      view.leadingAnchor.constraint(equalTo: musicSearchTypeAheadTableView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: musicSearchTypeAheadTableView.trailingAnchor),
      view.bottomAnchor.constraint(equalTo: musicSearchTypeAheadTableView.bottomAnchor),
    ])
    
    musicSearchBar.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      musicSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      musicSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      musicSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      musicSearchBar.heightAnchor.constraint(equalToConstant: 44),
    ])
  }
}

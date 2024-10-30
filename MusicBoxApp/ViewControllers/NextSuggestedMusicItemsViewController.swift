//
//  NextSuggestedMusicItemsViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 29/10/24.
//
import UIKit

class NextSuggestedMusicItemsViewController: UIViewController {
  let musicItemsTableView = MusicItemsTableView()
  let musicViewModel = MusicBrowsingViewModel()
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.title = "Next Suggested Music"
    view.addSubview(musicItemsTableView)
    musicItemsTableView.bindWithViewModel(viewModel: musicViewModel)
    musicViewModel.setMusicListQuery(.withSearchQuery(query: "Odia songs"))
    
    NSLayoutConstraint.activate([
      musicItemsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      musicItemsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      musicItemsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      musicItemsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    ])
  }
  
}

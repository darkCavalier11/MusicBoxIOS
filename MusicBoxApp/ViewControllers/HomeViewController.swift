//
//  HomeViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
  private var searchController = UISearchController()
  private var searchBar = UISearchBar()
  private let viewModel = HomeSearchViewModel()
  let disposeBag = DisposeBag()
  
  private let searchScreenTableView = SearchScreenTableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Welcome"
    searchController.searchBar.delegate = self
    navigationItem.searchController = searchController
    viewModel.hideSearchView.bind(to: searchScreenTableView.rx.isHidden).disposed(by: disposeBag)
    view.addSubview(searchScreenTableView)
    searchScreenTableView.delegate = nil
    searchScreenTableView.dataSource = nil
    
    viewModel
      .typeAheadSearchResult
      .bind(
        to: searchScreenTableView.rx.items(
          cellIdentifier: SearchScreenTableView.reuseIdentifier,
          cellType: SearchScreenTableViewCell.self
        )
      ) { row, element, cell in
        cell.textLabel?.text = element
      }
      .disposed(by: disposeBag)
    
    searchScreenTableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: searchScreenTableView.topAnchor),
      view.leadingAnchor.constraint(equalTo: searchScreenTableView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: searchScreenTableView.trailingAnchor),
      view.bottomAnchor.constraint(equalTo: searchScreenTableView.bottomAnchor),
    ])
  }
}

extension HomeViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.searchTextDidChange(searchText)
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    viewModel.becomeFirstResponder()
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    guard let text = searchBar.text else { return }
    viewModel.searchButtonTapped(text)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    viewModel.resignFirstResponder()
  }
}

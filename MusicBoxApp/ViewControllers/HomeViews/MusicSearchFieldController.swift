//
//  MusicSearchFieldController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 21/10/24.
//

import UIKit
import RxSwift

class MusicSearchFieldController: UISearchController {
  private let disposeBag = DisposeBag()
  override init(searchResultsController: UIViewController? = nil) {
    super.init(searchResultsController: searchResultsController)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bindWithViewModel(viewModel: SearchViewModel) {
    searchBar.rx.textDidBeginEditing.bind {
      viewModel.becomeFirstResponder()
    }
    .disposed(by: disposeBag)
    
    searchBar.rx.textDidEndEditing.bind { [weak self] in
      guard let text = self?.searchBar.text else { return }
      viewModel.resignFirstResponder()
    }
    .disposed(by: disposeBag)
    
    searchBar.rx.cancelButtonClicked.bind {
      viewModel.resignFirstResponder()
    }
    .disposed(by: disposeBag)
    
    searchBar.rx.searchButtonClicked.bind { [weak self] in
      guard let text = self?.searchBar.text else { return }
      viewModel.resignFirstResponder()
    }
    .disposed(by: disposeBag)
    
    searchBar.searchTextField.rx.controlEvent(.editingChanged)
      .bind { [weak self] in
        guard let text = self?.searchBar.text else { return }
        viewModel.searchTextDidChange(text)
      }
      .disposed(by: disposeBag)
  }
  
}

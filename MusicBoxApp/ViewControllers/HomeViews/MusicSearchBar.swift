//
//  MusicSearchFieldController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 21/10/24.
//

import UIKit
import RxSwift

class MusicSearchBar: UISearchBar {
  private let disposeBag = DisposeBag()
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.searchTextField.font = .preferredCustomFont(forTextStyle: .body)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bindWithViewModel(viewModel: SearchViewModel) {
    self.rx.textDidBeginEditing.bind {
      viewModel.becomeFirstResponder()
    }
    .disposed(by: disposeBag)
    
    self.rx.textDidEndEditing.bind {
      viewModel.resignFirstResponder()
    }
    .disposed(by: disposeBag)
    
    self.rx.cancelButtonClicked.bind {
      viewModel.resignFirstResponder()
    }
    .disposed(by: disposeBag)
    
    self.rx.searchButtonClicked.bind {
      viewModel.resignFirstResponder()
    }
    .disposed(by: disposeBag)
    
    self.searchTextField.rx.controlEvent(.editingChanged)
      .bind { [weak self] in
        guard let text = self?.text else { return }
        viewModel.searchTextDidChange(text)
      }
      .disposed(by: disposeBag)
  }
  
}

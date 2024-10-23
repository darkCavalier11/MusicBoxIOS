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
  private let activityIndicator = UIActivityIndicatorView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.searchTextField.font = .preferredCustomFont(forTextStyle: .body)
    self.addSubview(activityIndicator)
    activityIndicator.startAnimating()
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      activityIndicator.trailingAnchor.constraint(equalTo: self.searchTextField.trailingAnchor, constant: -5),
      activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bindWithViewModel(viewModel: SearchViewModel) {
    self.searchTextField.rx.controlEvent(.editingChanged)
      .bind { [weak self] in
        guard let text = self?.text else { return }
        if !text.isEmpty {
          
        }
        viewModel.searchTextDidChange(text)
      }
      .disposed(by: disposeBag)
    
    viewModel
      .showingHUD
      .bind { isLoading in
        DispatchQueue.main.async {
          if isLoading {
            self.searchTextField.clearButtonMode = .never
            self.activityIndicator.isHidden = false
          } else {
            self.searchTextField.clearButtonMode = .whileEditing
            self.activityIndicator.isHidden = true
          }
        }
      }
      .disposed(by: disposeBag)
  }
  
}

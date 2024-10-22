//
//  File.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit
import RxSwift

class MusicSearchTypeAheadTableView: UITableView {
  static let reuseIdentifier: String = "SearchScreenTableViewCell"
  private let disposeBag = DisposeBag()
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: .plain)
    register(SearchScreenTableViewCell.self, forCellReuseIdentifier: Self.reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bindWithViewModel(viewModel: SearchViewModel) {
    self.delegate = nil
    self.dataSource = nil
    
    viewModel
      .typeAheadSearchResult
      .bind(
        to: self.rx.items(
          cellIdentifier: MusicSearchTypeAheadTableView.reuseIdentifier,
          cellType: SearchScreenTableViewCell.self
        )
      ) { row, element, cell in
        cell.textLabel?.text = element
      }
      .disposed(by: disposeBag)
  }
}

class SearchScreenTableViewCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    self.textLabel?.font = .preferredCustomFont(forTextStyle: .body)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

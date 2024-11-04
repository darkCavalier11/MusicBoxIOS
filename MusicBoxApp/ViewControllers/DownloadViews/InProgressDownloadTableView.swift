//
//  InProgressDownloadTableView.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 04/11/24.
//

import UIKit

class InProgressDownloadTableView: UITableView {
  static let reusableIdentifier = "InProgressDownloadTableViewCell"
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.separatorStyle = .none
    register(InProgressDownloadTableViewCell.self, forCellReuseIdentifier: Self.reusableIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class InProgressDownloadTableViewCell: UITableViewCell {
  var musicDownloadItem: MusicDownloadItem? = nil
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = .accent.withAlphaComponent(0.1)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

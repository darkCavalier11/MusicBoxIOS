//
//  InProgressDownloadViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 04/11/24.
//

import UIKit
import RxSwift
import MusicBox
import Swinject

class InProgressDownloadViewController: UIViewController {
  private let inProgressDownloadTableView = InProgressDownloadTableView()
  private let downloadViewModel = Container.sharedContainer.resolve(DownloadViewModel.self)!
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "In Progress Download(s)"
    label.font = .preferredCustomFont(forTextStyle: .title3, fontName: UIFont.RethinkSans.bold.rawValue)
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(inProgressDownloadTableView)
    view.addSubview(titleLabel)
    view.backgroundColor = .systemBackground
    inProgressDownloadTableView.bindWithViewModel(viewModel: downloadViewModel)
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      
      inProgressDownloadTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      inProgressDownloadTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      inProgressDownloadTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      inProgressDownloadTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}

//
//  InProgressDownloadViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 04/11/24.
//

import UIKit

class InProgressDownloadViewController: UIViewController {
  private let inProgressDownloadTableView = InProgressDownloadTableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    inProgressDownloadTableView.delegate = self
    inProgressDownloadTableView.dataSource = self
    view.addSubview(inProgressDownloadTableView)
    
    NSLayoutConstraint.activate([
      inProgressDownloadTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      inProgressDownloadTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      inProgressDownloadTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      inProgressDownloadTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}

extension InProgressDownloadViewController: UITableViewDelegate {
  
}

extension InProgressDownloadViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: InProgressDownloadTableView.reusableIdentifier, for: indexPath)
    return cell
  }
}

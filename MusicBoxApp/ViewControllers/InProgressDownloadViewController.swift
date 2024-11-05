//
//  InProgressDownloadViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 04/11/24.
//

import UIKit
import RxSwift
import MusicBox

class InProgressDownloadViewController: UIViewController {
  private let inProgressDownloadTableView = InProgressDownloadTableView()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "In Progress Download(s)"
    label.font = .preferredCustomFont(forTextStyle: .title3, fontName: UIFont.RethinkSans.bold.rawValue)
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    inProgressDownloadTableView.delegate = self
    inProgressDownloadTableView.dataSource = self
    view.addSubview(inProgressDownloadTableView)
    view.addSubview(titleLabel)
    view.backgroundColor = .systemBackground
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      
      inProgressDownloadTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: InProgressDownloadTableView.reusableIdentifier, for: indexPath) as? InProgressDownloadTableViewCell else {
      return UITableViewCell()
    }
    cell.musicDownloadItem = MusicDownloadItem(
      identifier: 0,
      musicItem: MusicItem(
        title: "Test Music Item 1",
        publisherTitle: "Test Publisher 1",
        runningDurationInSeconds: 100,
        musicId: "A",
        smallestThumbnail: MusicItem.defaultSmallestThumbnail
      ),
      fractionDownloaded: .init(value: 0)
    )
    return cell
  }
}

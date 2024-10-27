//
//  SettingsViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit

class DownloadsViewController: UIViewController {
  private let noDownloadsFoundView = NoDownloadsFoundView()
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Downloads"
    
    view.addSubview(noDownloadsFoundView)
    NSLayoutConstraint.activate([
      noDownloadsFoundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      noDownloadsFoundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      noDownloadsFoundView.widthAnchor.constraint(equalToConstant: 250)
    ])
  }
  
  
}

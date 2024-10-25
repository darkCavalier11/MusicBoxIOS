//
//  SettingsNavigationController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit

class DownloadsNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.prefersLargeTitles = true
    viewControllers = [SettingsViewController()]
  }
}

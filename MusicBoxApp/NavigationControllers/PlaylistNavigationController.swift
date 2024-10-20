//
//  PlaylistNavigationController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit

class PlaylistNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.prefersLargeTitles = true
    viewControllers = [PlaylistViewController()]
  }
}

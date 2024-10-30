//
//  HomeTabViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit

class TabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let hnc = HomeNavigationController()
    let pnc = PlaylistNavigationController()
    let dnc = DownloadsNavigationController()
    
    let musicPlayingBarView = MusicPlayingBarThumbnailView()
    view.addSubview(musicPlayingBarView)
    NSLayoutConstraint.activate([
      musicPlayingBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      musicPlayingBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      musicPlayingBarView.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor),
      musicPlayingBarView.heightAnchor.constraint(equalToConstant: 80)
    ])
    hnc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "music.house"), tag: 0)
    pnc.tabBarItem = UITabBarItem(title: "Playlist", image: UIImage(systemName: "music.note.list"), tag: 1)
    dnc.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.circle"), tag: 2)
    
    viewControllers = [
      hnc,pnc,dnc
    ]
  }
}

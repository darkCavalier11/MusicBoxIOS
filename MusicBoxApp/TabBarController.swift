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
    let snc = SettingsNavigationController()
    
    hnc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "music.house"), tag: 0)
    pnc.tabBarItem = UITabBarItem(title: "Playlist", image: UIImage(systemName: "music.note.list"), tag: 1)
    snc.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.circle"), tag: 2)
    
    viewControllers = [
      pnc,hnc,snc
    ]
    
    selectedTab = pnc.tab
  }
}

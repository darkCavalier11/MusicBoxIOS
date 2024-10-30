//
//  HomeTabViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit
import Swinject

class TabBarController: UITabBarController {
  private let musicPlayingBarView = MusicPlayingBarThumbnailView()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let hnc = HomeNavigationController()
    let pnc = PlaylistNavigationController()
    let dnc = DownloadsNavigationController()
    
    hnc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "music.house"), tag: 0)
    pnc.tabBarItem = UITabBarItem(title: "Playlist", image: UIImage(systemName: "music.note.list"), tag: 1)
    dnc.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.circle"), tag: 2)
    
    viewControllers = [
      hnc,pnc,dnc
    ]
    
    view.addSubview(musicPlayingBarView)
    let playingViewModel = Container.sharedContainer.resolve(PlayingViewModel.self)!
    musicPlayingBarView.bindWithViewModel(viewModel: playingViewModel)
    setupPlayingThumbnailViewContraint()
  }
  
  func setupPlayingThumbnailViewContraint() {
    NSLayoutConstraint.activate([
      musicPlayingBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      musicPlayingBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      musicPlayingBarView.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor),
      musicPlayingBarView.heightAnchor.constraint(equalToConstant: 80)
    ])
  }
}

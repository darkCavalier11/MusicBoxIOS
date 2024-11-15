//
//  HomeTabViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit
import Swinject
import Network

class TabBarController: UITabBarController {
  private let musicPlayingBarView = MusicPlayingBarThumbnailView()
  
  private let networkMonitor = NWPathMonitor()
  
  private let noInternetContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .darkText
    return view
  }()
  
  private let noInternetLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Device not connected to internet."
    label.textColor = .lightText
    label.font = .preferredCustomFont(forTextStyle: .caption1)
    return label
  }()
  
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
    
    
    musicPlayingBarView.bindWithViewModel()
    let tapGestureRecognizer = UITapGestureRecognizer()
    tapGestureRecognizer.addTarget(self, action: #selector(handleTapGestureRecognizer))
    musicPlayingBarView.addGestureRecognizer(tapGestureRecognizer)
    setupPlayingThumbnailViewContraint()
    
    noInternetContainerView.addSubview(noInternetLabel)
    view.addSubview(noInternetContainerView)
    setupNoInternetViewContraint()
    networkMonitor.pathUpdateHandler = { [weak self] path in
      if path.status == .satisfied {
        DispatchQueue.main.async {
          self?.noInternetContainerView.isHidden = true
        }
      } else {
        DispatchQueue.main.async {
          self?.noInternetContainerView.isHidden = false
        }
      }
    }
    networkMonitor.start(queue: DispatchQueue.global())
  }
  
  @objc func handleTapGestureRecognizer() {
    let musicDetailsViewController = MusicPlayingDetailsViewController()
    musicDetailsViewController.modalPresentationStyle = .fullScreen
    self.present(musicDetailsViewController, animated: true)
  }
  
  func setupPlayingThumbnailViewContraint() {
    NSLayoutConstraint.activate([
      musicPlayingBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      musicPlayingBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      musicPlayingBarView.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor),
      musicPlayingBarView.heightAnchor.constraint(equalToConstant: 80)
    ])
  }
  
  func setupNoInternetViewContraint() {
    NSLayoutConstraint.activate([
      noInternetContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      noInternetContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      noInternetContainerView.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor),
      noInternetContainerView.heightAnchor.constraint(equalToConstant: 50),
      noInternetLabel.centerXAnchor.constraint(equalTo: noInternetContainerView.centerXAnchor),
      noInternetLabel.centerYAnchor.constraint(equalTo: noInternetContainerView.centerYAnchor),
    ])
  }
}

//
//  PlaylistViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit

class PlaylistViewController: UIViewController {
  private let noPlaylistFoundView = NoPlaylistFoundView()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(noPlaylistFoundView)
    navigationItem.title = "Your playlists"
    view.addSubview(noPlaylistFoundView)
    NSLayoutConstraint.activate([
      noPlaylistFoundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      noPlaylistFoundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      noPlaylistFoundView.widthAnchor.constraint(equalToConstant: 250),
    ])
  }
}

//
//  PlaylistViewController.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 20/10/24.
//

import UIKit

class PlaylistViewController: UIViewController {
  private let noPlaylistFoundView = NoPlaylistFoundView()
  private let playlistTableView = PlaylistTableView()
  override func viewDidLoad() {
    super.viewDidLoad()
    playlistTableView.delegate = self
    playlistTableView.dataSource = self
    
//    view.addSubview(noPlaylistFoundView)
    navigationItem.title = "Your playlists"
    view.addSubview(playlistTableView)
//    NSLayoutConstraint.activate([
//      noPlaylistFoundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//      noPlaylistFoundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//      noPlaylistFoundView.widthAnchor.constraint(equalToConstant: 250),
//    ])
    
    NSLayoutConstraint.activate([
      playlistTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      playlistTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      playlistTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      playlistTableView.topAnchor.constraint(equalTo: view.topAnchor)
    ])
  }
}

extension PlaylistViewController: UITableViewDelegate {
  
}

extension PlaylistViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableView.reusableIdentifier, for: indexPath)
    return cell
  }
}

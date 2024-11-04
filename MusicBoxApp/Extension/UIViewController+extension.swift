//
//  UIViewController+extension.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 04/11/24.
//
import UIKit
import Swinject
import MusicBox

extension UIViewController: MusicItemTableViewActionDelegate {
  func navigateToAddToPlaylistScreen(for musicItem: MusicItem) {
    let musicViewModel = Container.sharedContainer.resolve(BrowsingViewModel.self)!
    musicViewModel.addMusicToPlaylist(controller: self, musicItem: musicItem)
  }
  
  func startDownload(for musicItem: MusicItem) {
    let downloadViewModel = Container.sharedContainer.resolve(DownloadViewModel.self)!
    downloadViewModel.addToDownloadQueue(musicItem: musicItem)
  }
}

//
//  DownloadViewModel.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 03/11/24.
//

import Foundation
import RxSwift
import RxCocoa
import MusicBox

protocol DownloadViewModel {
  func addToDownloadQueue(musicItem: MusicItem)
  var downloadQueue: Observable<[MusicDownloadItem]> { get }
}

class MusicDownloadItem {
  let identifier: Int
  let musicItem: MusicItem
  var fractionDownloaded: Double
  
  init(identifier: Int, musicItem: MusicItem, fractionDownloaded: Double) {
    self.identifier = identifier
    self.musicItem = musicItem
    self.fractionDownloaded = fractionDownloaded
  }
}

class MusicDownloadViewModel: NSObject, DownloadViewModel, URLSessionDownloadDelegate {
  private let downloadQueueRelay = BehaviorRelay<[MusicDownloadItem]>(value: [])
  
  var downloadQueue: Observable<[MusicDownloadItem]> {
    downloadQueueRelay.asObservable()
  }
  
  func addToDownloadQueue(musicItem: MusicItem) {
    guard let url = URL(string: "https://mp4-download.com/4k-MP4") else {
      return
    }
    let request = URLRequest(url: url)
    let task = session.downloadTask(
      with: request
    )
    
    task.resume()
  }
  
  func urlSession(
    _ session: URLSession,
    downloadTask: URLSessionDownloadTask,
    didFinishDownloadingTo location: URL
  ) {
      
  }
  
  func urlSession(
    _ session: URLSession,
    downloadTask: URLSessionDownloadTask,
    didWriteData bytesWritten: Int64,
    totalBytesWritten: Int64,
    totalBytesExpectedToWrite: Int64
  ) {
    
  }
  
  lazy var session = URLSession(
    configuration: .background(withIdentifier: Bundle.main.bundleIdentifier!),
    delegate: self,
    delegateQueue: OperationQueue()
  )
}

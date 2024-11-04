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
import os

protocol DownloadViewModel {
  func addToDownloadQueue(musicItem: MusicItem)
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
  static private let logger = Logger(subsystem: "com.MusicBoxApp.Download", category: "MusicDownloadViewModel")
  
  private let musicBox: MusicBox
  private let coreDataStack: CoreDataStack
  let musicItemModelService: MusicItemModelServices!
  init(musicBox: MusicBox, coreDataStack: CoreDataStack) {
    self.musicBox = musicBox
    self.coreDataStack = coreDataStack
    self.musicItemModelService = MusicItemModelServices(
      coreDataStack: coreDataStack,
      context: coreDataStack.managedObjectContext
    )
  }
  
  var downloadQueue = [MusicDownloadItem]()
  let defaultDownloadDirectory: URL? = {
    let fm = FileManager.default
    guard let documentURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    let downloadDir = documentURL.appending(path: "OfflineMusicDownloads")
    return downloadDir
  }()
  
  func addToDownloadQueue(musicItem: MusicItem) {
    Task {
      guard let musicDownloadURL = await musicBox.musicSession.getMusicStreamingURL(musicId: musicItem.musicId) else {
        return
      }
      let request = URLRequest(url: musicDownloadURL)
      let task = session.downloadTask(
        with: request
      )
      downloadQueue.append(
        MusicDownloadItem(
          identifier: task.taskIdentifier,
          musicItem: musicItem,
          fractionDownloaded: 0
        )
      )
      task.resume()
    }
  }
  
  func urlSession(
    _ session: URLSession,
    downloadTask: URLSessionDownloadTask,
    didFinishDownloadingTo location: URL
  ) {
    guard let index = downloadQueue.firstIndex(where: { item in
      item.identifier == downloadTask.taskIdentifier
    }) else {
      return
    }
    let musicItem = downloadQueue[index].musicItem
    let newLocationURL = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask
    )
      .first!
      .appending(path: musicItem.title)
      .appendingPathExtension("m4a")
    do {
      try FileManager.default.moveItem(at: location, to: newLocationURL)
      
      musicItemModelService.insertNewMusicItemModelWithLocalStorage(
        musicItem: musicItem,
        withLocalStorageURL: newLocationURL
      )
    } catch {
      Self.logger.error("Error downloading music item \(musicItem.title)")
    }
    
    downloadQueue.remove(at: index)
  }
  
  func urlSession(
    _ session: URLSession,
    downloadTask: URLSessionDownloadTask,
    didWriteData bytesWritten: Int64,
    totalBytesWritten: Int64,
    totalBytesExpectedToWrite: Int64
  ) {
    let fractionDownloaded = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
    print(fractionDownloaded)
  }
  
  lazy var session = URLSession(
    configuration: .background(withIdentifier: Bundle.main.bundleIdentifier!),
    delegate: self,
    delegateQueue: OperationQueue()
  )
}

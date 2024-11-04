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
  func removeDownloadedItem(musicItemModel: MusicItemModel)
  var playingViewModel: PlayingViewModel { get }
  var inProgressDownlods: Observable<[MusicDownloadItem]> { get }
}

class MusicDownloadItem: Equatable, Hashable {
  static func == (lhs: MusicDownloadItem, rhs: MusicDownloadItem) -> Bool {
    lhs.identifier == rhs.identifier &&
    lhs.musicItem == rhs.musicItem
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
    hasher.combine(musicItem)
  }
  
  let identifier: Int
  let musicItem: MusicItem
  var fractionDownloaded: BehaviorRelay<Double>
  
  init(identifier: Int, musicItem: MusicItem, fractionDownloaded: BehaviorRelay<Double>) {
    self.identifier = identifier
    self.musicItem = musicItem
    self.fractionDownloaded = fractionDownloaded
  }
}

final class MusicDownloadViewModel:
  NSObject, DownloadViewModel, URLSessionDownloadDelegate {
  static private let logger = Logger(subsystem: "com.MusicBoxApp.Download", category: "MusicDownloadViewModel")
  
  private let musicBox: MusicBox
  private let coreDataStack: CoreDataStack
  let musicItemModelService: MusicItemModelServices!
  let playingViewModel: PlayingViewModel
  init(
    musicBox: MusicBox,
    coreDataStack: CoreDataStack,
    playingViewModel: PlayingViewModel
  ) {
    self.musicBox = musicBox
    self.coreDataStack = coreDataStack
    self.musicItemModelService = MusicItemModelServices(
      coreDataStack: coreDataStack,
      context: coreDataStack.managedObjectContext
    )
    self.playingViewModel = playingViewModel
  }
  
  var downloadQueue = [MusicDownloadItem]()
  
  var downloadQueueRelay = BehaviorRelay<[MusicDownloadItem]>(value: [])
  func removeDownloadedItem(musicItemModel: MusicItemModel) {
    musicItemModelService.removeMusicItemModel(model: musicItemModel)
  }
  
  var inProgressDownlods: Observable<[MusicDownloadItem]> {
    downloadQueueRelay.asObservable()
  }
  
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
          fractionDownloaded: .init(value: 0.0)
        )
      )
      downloadQueueRelay.accept(downloadQueue)
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
    downloadQueueRelay.accept(downloadQueue)
  }
  
  func urlSession(
    _ session: URLSession,
    downloadTask: URLSessionDownloadTask,
    didWriteData bytesWritten: Int64,
    totalBytesWritten: Int64,
    totalBytesExpectedToWrite: Int64
  ) {
    let fractionDownloaded = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
    guard let index = downloadQueue.firstIndex(where: { item in
      item.identifier == downloadTask.taskIdentifier
    }) else {
      return
    }
    downloadQueue[index].fractionDownloaded.accept(fractionDownloaded)
    downloadQueueRelay.accept(downloadQueue)
  }
  
  lazy var session = URLSession(
    configuration: .background(withIdentifier: Bundle.main.bundleIdentifier!),
    delegate: self,
    delegateQueue: OperationQueue()
  )
}

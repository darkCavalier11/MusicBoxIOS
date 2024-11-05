//
//  DownloadViewModelTests.swift
//  MusicBoxAppTests
//
//  Created by Sumit Pradhan on 05/11/24.
//

import Foundation
@testable import MusicBoxApp
import RxSwift
import RxCocoa
import MusicBox
import XCTest

final class TestDownloadViewModel: DownloadViewModel {
  var downloadQueue = [MusicDownloadItem]()
  var downloadQueueRelay = BehaviorRelay<[MusicDownloadItem]>(value: [])
  var testCoreDataStack = TestCoreDataStack()
  
  func addToDownloadQueue(musicItem: MusicItem) {
    let musicDownloadItem = MusicDownloadItem(
      identifier: 0,
      musicItem: musicItem,
      fractionDownloaded: .init(value: 0)
    )
    downloadQueue.append(musicDownloadItem)
    downloadQueueRelay.accept(downloadQueue)
  }
  
  func removeDownloadedItem(musicItemModel: MusicItemModel) {
    let service = MusicItemModelServices(
      coreDataStack: testCoreDataStack,
      context: testCoreDataStack.managedObjectContext
    )
    
    service.removeMusicItemModel(model: musicItemModel)
  }
  
  var playingViewModel: any PlayingViewModel = TestMusicPlayingViewModel()
  
  var inProgressDownlods: Observable<[MusicDownloadItem]> {
    downloadQueueRelay.asObservable()
  }
}

final class DownloadViewModelTests: XCTestCase {
  var downloadViewModel: DownloadViewModel!
  var disposeBag: DisposeBag!
  
  private let testMusicItem = MusicItem(
    title: "1",
    publisherTitle: "P",
    runningDurationInSeconds: 0,
    musicId: "X",
    smallestThumbnail: nil,
    largestThumbnail: nil
  )

  
  override func setUpWithError() throws {
    disposeBag = DisposeBag()
    downloadViewModel = TestDownloadViewModel()
  }
  
  override func tearDown() async throws {
    disposeBag = nil
    downloadViewModel = nil
  }
  
  func testAddingDownloadItemInQueue() {
    let expectation = expectation(description: "Adding a download item to queue should increment the queue count")
    
    downloadViewModel
      .inProgressDownlods
      .bind { musicItems in
        if musicItems.count == 1 {
          expectation.fulfill()
        }
      }
      .disposed(by: disposeBag)
    
    downloadViewModel
      .addToDownloadQueue(musicItem: testMusicItem)
    
    wait(for: [expectation])
  }
}

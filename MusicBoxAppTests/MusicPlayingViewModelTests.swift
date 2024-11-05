//
//  MusicViewModel.swift
//  MusicBoxAppTests
//
//  Created by Sumit Pradhan on 21/10/24.
//

import XCTest
@testable import MusicBoxApp
import RxSwift
import RxCocoa
import MusicBox

final class TestMusicPlayingViewModel: PlayingViewModel {
  private let testMusicPlayingStatusRelay = BehaviorRelay(value: MusicPlayingStatus.unknown)
  private let testSelectedMusicItemRelay = BehaviorRelay<MusicItem?>(value: nil)
  
  private let testMusicItem = MusicItem(
    title: "1",
    publisherTitle: "P",
    runningDurationInSeconds: 0,
    musicId: "X",
    smallestThumbnail: nil,
    largestThumbnail: nil
  )
  
  var musicPlayingStatus: Observable<MusicPlayingStatus> {
    testMusicPlayingStatusRelay.asObservable()
  }
  
  func playMusicItem(musicItem: MusicItem) {
    testMusicPlayingStatusRelay.accept(.readyToPlay)
    testSelectedMusicItemRelay.accept(musicItem)
  }
  
  var selectedMusicItem: Observable<MusicItem?> {
    testSelectedMusicItemRelay.asObservable()
  }
}

final class MusicPlayingViewModelTests: XCTestCase {
  var viewModel: TestMusicPlayingViewModel!
  var disposeBag: DisposeBag!
  
  override func setUpWithError() throws {
    disposeBag = DisposeBag()
    viewModel = TestMusicPlayingViewModel()
  }
  
  override func tearDown() async throws {
    viewModel = nil
    disposeBag = nil
  }
  
  func testMusicPlayingStatus() {
    let expectation1 = expectation(description: "At begin the state of music item should be idle")
    let expectation2 = expectation(description: "When music item selected, the status of music item should be initialising")
    
    let testMusicItem = MusicItem(title: "Test", publisherTitle: "ABCD", runningDurationInSeconds: 10, musicId: "123")
    viewModel
      .musicPlayingStatus
      .subscribe(
        onNext: { status in
          switch status {
          case .readyToPlay:
            expectation2.fulfill()
          case .unknown:
            expectation1.fulfill()
          default:
            XCTFail()
          }
        })
      .disposed(by: disposeBag)
    
    viewModel.playMusicItem(musicItem: testMusicItem)
    waitForExpectations(timeout: 1)
  }
  
  func testSelectedMusic() {
    let expectation = expectation(description: "When played music item should be valid one")
    
    let testMusicItem = MusicItem(title: "Test", publisherTitle: "ABCD", runningDurationInSeconds: 10, musicId: "123")
    viewModel
      .selectedMusicItem
      .subscribe(
        onNext: { musicItem in
          if musicItem?.musicId == testMusicItem.musicId {
            expectation.fulfill()
          }
        })
      .disposed(by: disposeBag)
    
    viewModel.playMusicItem(
      musicItem: testMusicItem
    )
    waitForExpectations(timeout: 1)
  }
}

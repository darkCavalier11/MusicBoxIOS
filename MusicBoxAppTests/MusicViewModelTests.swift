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

final class TestHomeViewModel: MusicViewModel {
  func dismissMusicItem(musicPlaylistModel: MusicBoxApp.MusicPlaylistModel, index: Int, onDismissed: (() -> Void)?) {
    
  }
  
  func addMusicToPlaylist(controller: UINavigationController, musicItem: MusicItem) {
    
  }
  
  func startDowloadingMusic(_ musicItem: MusicItem) {
    
  }
  
  private let testIsFetchingMusicListRelay = BehaviorRelay(value: false)
  private let testMusicListRelay = BehaviorRelay(value: [MusicItem]())
  private let testMusicQueryTypeRelay = BehaviorRelay(value: MusicListQueryType.defaultMusicList)
  private let testMusicPlayingStatusRelay = BehaviorRelay(value: MusicPlayingStatus.idle)
  private let testSelectedMusicItemRelay = BehaviorRelay<MusicItem?>(value: nil)
  
  private let testMusicItem = MusicItem(
    title: "1",
    publisherTitle: "P",
    runningDurationInSeconds: 0,
    musicId: "X",
    smallestThumbnail: nil,
    largestThumbnail: nil
  )
  
  var isFetchingMusicList: Observable<Bool> {
    testIsFetchingMusicListRelay.asObservable()
  }
  
  var musicPlayingStatus: Observable<MusicPlayingStatus> {
    testMusicPlayingStatusRelay.asObservable()
  }
  
  func setMusicListQuery(_ query: MusicListQueryType) {
    testMusicQueryTypeRelay.accept(query)
  }
  
  func playMusicItem(musicItem: MusicItem) {
    testMusicPlayingStatusRelay.accept(.initialising)
    testSelectedMusicItemRelay.accept(musicItem)
  }
  
  var selectedMusicItem: Observable<MusicItem?> {
    testSelectedMusicItemRelay.asObservable()
  }
  
  var musicItemList: Observable<[MusicItem]> {
    testMusicQueryTypeRelay
      .flatMap { [weak self] queryType in
        Observable.create { [weak self] observer in
          guard let self = self else { return Disposables.create() }
          self.testIsFetchingMusicListRelay.accept(true)
          sleep(1)
          switch queryType {
          case .defaultMusicList:
            observer.onNext([self.testMusicItem])
          case .withSearchQuery(_):
            observer.onNext([self.testMusicItem])
          case .playlist(id: _):
            observer.onNext([self.testMusicItem])
          }
          self.testIsFetchingMusicListRelay.accept(false)
          return Disposables.create()
        }
      }
  }
}

final class MusicViewModelTests: XCTestCase {
  var viewModel: TestHomeViewModel!
  var disposeBag: DisposeBag!
  
  override func setUpWithError() throws {
    disposeBag = DisposeBag()
    viewModel = TestHomeViewModel()
  }
  
  override func tearDown() async throws {
    viewModel = nil
    disposeBag = nil
  }
  
  func testIsFetchimgMusiclist() {
    let expectation = expectation(description: "When fetching, musiclist status fetching should be true")
    viewModel.isFetchingMusicList.bind { status in
      if status {
        expectation.fulfill()
      }
    }
    .disposed(by: disposeBag)
    
    viewModel
      .musicItemList
      .bind { _ in
        
      }
      .disposed(by: disposeBag)
      
    waitForExpectations(timeout: 2)
  }
  
  func testFetchingDefaultMusicList() {
    let expectation = expectation(
      description: "When searching for default music list it should return some value. Assuming here the user already listened few musics earlier.")
    
    viewModel
      .musicItemList
      .subscribe(onNext: { musicList in
        XCTAssertTrue(!musicList.isEmpty)
        expectation.fulfill()
      })
      .disposed(by: disposeBag)
    waitForExpectations(timeout: 1)
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
        case .initialising:
            expectation2.fulfill()
        case .idle:
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
          print(musicItem)
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

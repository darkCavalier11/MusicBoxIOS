//
//  PlayingViewModel.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 30/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import MusicBox
import MediaPlayer

protocol PlayingViewModel {
  var musicPlayingStatus: Observable<MusicPlayingStatus> { get }
  var selectedMusicItem: Observable<MusicItem?> { get }
  func playMusicItem(musicItem: MusicItem)
  var currentTimeInSeconds: Observable<Int> { get }
}

class MusicPlayingViewModel: NSObject, PlayingViewModel {
  private lazy var musicPlayingStatusRelay: BehaviorRelay<MusicPlayingStatus> = .init(value: .unknown)
  private let selectedMusicItemRelay = BehaviorRelay<MusicItem?>(value: nil)
  private let currentTimeInSecondsRelay = BehaviorRelay<Int>(value: 0)
  private let player = AVQueuePlayer()
  private let musicBox: MusicBox
  private var timeObserver: Any?
  
  init(musicBox: MusicBox) {
    self.musicBox = musicBox
    super.init()
    addPeriodicTimeObserver()
  }
  
  var selectedMusicItem: Observable<MusicItem?> {
    selectedMusicItemRelay.asObservable()
  }
  
  var musicPlayingStatus: Observable<MusicPlayingStatus> {
    musicPlayingStatusRelay.asObservable()
  }
  
  var currentTimeInSeconds: Observable<Int> {
    currentTimeInSecondsRelay.asObservable()
  }
  
  private func resetPlayer() {
    player.removeAllItems()
    musicPlayingStatusRelay.accept(.unknown)
    removePeriodicTimeObserver()
  }
  
  /// Adds an observer of the player timing.
  private func addPeriodicTimeObserver() {
    // Create a 0.5 second interval time.
    let interval = CMTime(value: 1, timescale: 2)
    timeObserver = player.addPeriodicTimeObserver(
      forInterval: interval,
      queue: .main
    ) { [weak self] time in
      guard let self else { return }
      self.currentTimeInSecondsRelay.accept(Int(time.seconds.rounded()))
    }
  }
  
  /// Removes the time observer from the player.
  private func removePeriodicTimeObserver() {
    guard let timeObserver else { return }
    player.removeTimeObserver(timeObserver)
    self.timeObserver = nil
  }
  
  func playMusicItem(musicItem: MusicItem) {
    musicPlayingStatusRelay.accept(.readyToPlay)
    selectedMusicItemRelay.accept(musicItem)
    
    Task {
      guard let streamingURL = await musicBox.musicSession.getMusicStreamingURL(musicId: musicItem.musicId) else {
        // TODO: - Handle by showing a toast
        return
      }
      player.removeAllItems()
      player.insert(.init(url: streamingURL), after: nil)
      player.play()
    }
  }
}

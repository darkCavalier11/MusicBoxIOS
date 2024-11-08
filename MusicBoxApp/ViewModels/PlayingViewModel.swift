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
import os
import AVFoundation

protocol PlayingViewModel {
  var musicPlayingStatus: Observable<MusicPlayingStatus> { get }
  var selectedMusicItem: Observable<MusicItem?> { get }
  func playMusicItem(musicItem: MusicItem)
  func pause()
  func resume()
  func seekToTime(seconds: Int, completion: @escaping () -> Void)
  func seekToNextMusicItem()
  func seekToPreviousMusicItem()
  var currentTimeInSeconds: Observable<Int> { get }
}

class MusicPlayingViewModel: NSObject, PlayingViewModel {
  static private let logger = Logger(
    subsystem: "com.MusicBoxApp.CoreData",
    category: "PlayingViewModel"
  )
  private lazy var musicPlayingStatusRelay: BehaviorRelay<MusicPlayingStatus> = .init(value: .unknown)
  private let selectedMusicItemRelay = BehaviorRelay<MusicItem?>(value: nil)
  private let currentTimeInSecondsRelay = BehaviorRelay<Int>(value: 0)
  
  private var recentlyPlayedMusicItems: [(AVPlayerItem, MusicItem)] = []
  private var recentlyPlayedIndex = -1
  
  let player = AVPlayer()
  private let musicBox: MusicBox
  private var timeObserver: Any?
  private var boundaryTimeObserver: Any?
  
  init(musicBox: MusicBox) {
    self.musicBox = musicBox
    super.init()
    addPeriodicTimeObserver()
    self.player.addObserver(self, forKeyPath: #keyPath(AVQueuePlayer.rate), options: [.new], context: nil)
  }
  
  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey : Any]?,
    context: UnsafeMutableRawPointer?
  ) {
    if keyPath == #keyPath(AVQueuePlayer.rate) {
      if player.rate == 0 {
        musicPlayingStatusRelay.accept(.paused)
      } else {
        musicPlayingStatusRelay.accept(.playing)
      }
    }
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
    currentTimeInSecondsRelay.accept(0)
    musicPlayingStatusRelay.accept(.unknown)
    player.seek(to: .zero)
    pause()
  }
  
  /// Observe when music goes to the end then go to the next item.
  private func addBoundaryTimeObserver(totalDuration: Int) {
    let interval = CMTime(value: Int64(totalDuration), timescale: 1)
    var breakpoints = [NSValue]()
    breakpoints.append(NSValue(time: interval))
    boundaryTimeObserver = player.addBoundaryTimeObserver(
      forTimes: breakpoints,
      queue: .main
    ) { [weak self] in
      self?.seekToNextMusicItem()
    }
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
      let currentProgressInSeconds = time.seconds
      self.currentTimeInSecondsRelay.accept(Int(currentProgressInSeconds))
      
      switch player.status {
      case .unknown:
        self.musicPlayingStatusRelay.accept(.unknown)
      case .failed:
        self.musicPlayingStatusRelay.accept(.error)
        self.currentTimeInSecondsRelay.accept(0)
      case .readyToPlay:
        break
      @unknown default:
        break
      }
    }
  }
  
  /// Removes the time observer from the player.
  private func removePeriodicTimeObserver() {
    guard let timeObserver else { return }
    player.removeTimeObserver(timeObserver)
    self.timeObserver = nil
  }
  private func removeBoundaryObserver() {
    guard let boundaryTimeObserver else { return }
    player.removeTimeObserver(boundaryTimeObserver)
    self.boundaryTimeObserver = nil
  }
  
  func playMusicItem(musicItem: MusicItem) {
    Self.logger.log("called \(#function)")
    musicPlayingStatusRelay.accept(.readyToPlay)
    selectedMusicItemRelay.accept(musicItem)
    resetPlayer()

    Task {
      guard let streamingURL = await musicBox.musicSession.getMusicStreamingURL(musicId: musicItem.musicId) else {
        // TODO: - Handle by showing a toast
        return
      }
      Self.logger.info("Got URL for music item \(musicItem.title)")
      let playerItem = AVPlayerItem(url: streamingURL)
      recentlyPlayedMusicItems.append((playerItem, musicItem))
      recentlyPlayedIndex = recentlyPlayedMusicItems.count - 1
      player.replaceCurrentItem(
        with: recentlyPlayedMusicItems[recentlyPlayedIndex].0
      )
      self.removeBoundaryObserver()
      self.addBoundaryTimeObserver(totalDuration: musicItem.runningDurationInSeconds)
      
      player.playImmediately(atRate: 1)
    }
  }
  
  func seekToNextMusicItem() {
    /// if recently played index less than the size of the items, we can increment the index and
    /// play that item, else we fetch the next item and play
    Self.logger.log("called \(#function)")
    resetPlayer()
    if recentlyPlayedIndex + 1 < recentlyPlayedMusicItems.count {
      recentlyPlayedIndex += 1
      let item = recentlyPlayedMusicItems[recentlyPlayedIndex]
      player.replaceCurrentItem(with: item.0)
      player.playImmediately(atRate: 1)
      self.removeBoundaryObserver()
      self.addBoundaryTimeObserver(totalDuration: item.1.runningDurationInSeconds)
      selectedMusicItemRelay.accept(item.1)
      return
    }
    guard let item = selectedMusicItemRelay.value else { return }
    Task {
      guard let nextMusicItem = await musicBox.musicSession.getNextSuggestedMusicItems(
        musicId: item.musicId
      ).first else { return }
      selectedMusicItemRelay.accept(nextMusicItem)
      guard let streamingURL = await musicBox.musicSession.getMusicStreamingURL(musicId: nextMusicItem.musicId) else {
        // TODO: - Handle by showing a toast
        return
      }
      let playerItem = AVPlayerItem(url: streamingURL)
      recentlyPlayedMusicItems.append((playerItem, nextMusicItem))
      recentlyPlayedIndex = recentlyPlayedMusicItems.count - 1
      self.removeBoundaryObserver()
      self.addBoundaryTimeObserver(totalDuration: nextMusicItem.runningDurationInSeconds)
      player.replaceCurrentItem(with: playerItem)
      player.playImmediately(atRate: 1)
    }
  }
  
  func seekToTime(seconds: Int, completion: @escaping () -> Void) {
    Self.logger.log("called \(#function)")
    let time = CMTime(value: Int64(seconds), timescale: 1)
    player.currentItem?.seek(to: time) { done in
      completion()
    }
  }
  
  func seekToPreviousMusicItem() {
    Self.logger.log("called \(#function)")
    resetPlayer()
    recentlyPlayedIndex = max(0, recentlyPlayedIndex-1)
    if recentlyPlayedIndex > recentlyPlayedMusicItems.count {
      return
    }
    let item = recentlyPlayedMusicItems[recentlyPlayedIndex]
    self.removeBoundaryObserver()
    self.addBoundaryTimeObserver(totalDuration: item.1.runningDurationInSeconds)
    self.selectedMusicItemRelay.accept(item.1)
    player.replaceCurrentItem(with: item.0)
    player.playImmediately(atRate: 1)
  }
  
  func pause() {
    Self.logger.log("called \(#function)")
    player.pause()
  }
  
  func resume() {
    Self.logger.log("called \(#function)")
    player.playImmediately(atRate: 1)
  }
}

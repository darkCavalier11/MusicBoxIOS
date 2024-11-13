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
import MediaPlayer

protocol PlayingViewModel {
  var musicPlayingStatus: Observable<MusicPlayingStatus> { get }
  var selectedMusicItem: Observable<MusicItem?> { get }
  func playMusicItem(musicItem: MusicItem)
  func pause()
  func resume()
  func seekToTime(seconds: Int, completion: @escaping () -> Void)
  func seekToNextMusicItem()
  func seekToPreviousMusicItem()
  func playPlaylist(playlistItems: [MusicItemModel])
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
  
  private var recentlyPlayedMusicItems: [(AVPlayerItem?, MusicItem)] = []
  private var recentlyPlayedIndex = -1
  
  private let player: AVPlayer
  private let musicBox: MusicBox
  private let coreDataStack: CoreDataStack
  
  private let disposeBag = DisposeBag()
  
  private var timeObserver: Any?
  private var boundaryTimeObserver: Any?
  
  init(musicBox: MusicBox,
       player: AVPlayer,
       coreDataStack: CoreDataStack
  ) {
    self.musicBox = musicBox
    self.player = player
    self.coreDataStack = coreDataStack
    super.init()
    addPeriodicTimeObserver()
    self.player.addObserver(
      self,
      forKeyPath: #keyPath(AVQueuePlayer.rate),
      options: [.new], context: nil
    )
    
    updatePlayingMetadata()
    setupRemoteCommandCenter()
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
        Self.logger.error("Error playing music")
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
    
    /// check if a local storage URL exist for this particular music item else fetch the HTTP URL
    let request = MusicItemModel.fetchRequest()
    request.predicate = NSPredicate(format: "musicId == %@", musicItem.musicId)
    if let results = try? coreDataStack.managedObjectContext.fetch(request),
       results.count > 0,
       let localStorageURL = results.first?.localStorageURL,
       FileManager.default.fileExists(atPath: localStorageURL.absoluteString)
    {
      Self.logger.info("Found music in local storage for music item \(musicItem.title)")
      let playerItem = AVPlayerItem(url: localStorageURL)
      recentlyPlayedMusicItems.append((playerItem, musicItem))
      recentlyPlayedIndex = recentlyPlayedMusicItems.count - 1
      player.replaceCurrentItem(
        with: recentlyPlayedMusicItems[recentlyPlayedIndex].0
      )
      self.removeBoundaryObserver()
      self.addBoundaryTimeObserver(totalDuration: musicItem.runningDurationInSeconds)
      
      player.playImmediately(atRate: 1)
    } else {
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
        
        await player.playImmediately(atRate: 1)
      }
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
      await player.playImmediately(atRate: 1)
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
  
  func playPlaylist(playlistItems: [MusicItemModel]) {
    recentlyPlayedMusicItems.removeAll()
    recentlyPlayedMusicItems = Array<(AVPlayerItem?, MusicItem)>(
      repeating:
        (
          nil,
          MusicItem(
            title: "",
            publisherTitle: "",
            runningDurationInSeconds: 0,
            musicId: ""
          )
        ),
      count: playlistItems.count
    )
    
    for (index, musicItemModel) in playlistItems.enumerated() {
      let musicItem = MusicItem(
        title: musicItemModel.title ?? "",
        publisherTitle: musicItemModel.publisherTitle ?? "",
        runningDurationInSeconds: Int(musicItemModel.runningDurationInSeconds),
        musicId: musicItemModel.musicId ?? "",
        smallestThumbnail: musicItemModel.smallestThumbnail, largestThumbnail: musicItemModel.largestThumbnail
      )
      if musicItemModel.localStorageURL != nil &&
          FileManager.default.fileExists(
        atPath: musicItemModel.localStorageURL?.absoluteString ?? ""
          ) {
        let playerItem = AVPlayerItem(url: musicItemModel.localStorageURL!)
        recentlyPlayedMusicItems[index] = (playerItem, musicItem)
        if index == 0 {
          recentlyPlayedIndex = -1
          seekToNextMusicItem()
        }
      } else {
        Task {
          guard let streamingURL = await musicBox.musicSession.getMusicStreamingURL(musicId: musicItem.musicId) else {
            // TODO: - Handle by showing a toast
            return
          }
          let playerItem = AVPlayerItem(url: streamingURL)
          recentlyPlayedMusicItems[index] = (playerItem, musicItem)
          if index == 0 {
            recentlyPlayedIndex = -1
            seekToNextMusicItem()
          }
        }
      }
    }
  }

  /// Function to set the Now Playing Info
  func updatePlayingMetadata() {
    let session = AVAudioSession()
    try! session.setActive(true)
    Observable
      .combineLatest(selectedMusicItem, currentTimeInSeconds)
      .bind { musicItem, progress in
        Task {
          guard let musicItem else { return }
          var nowPlayingInfo = [String: Any]()
          
          // Set metadata properties
          nowPlayingInfo[MPMediaItemPropertyTitle] = musicItem.title
          nowPlayingInfo[MPMediaItemPropertyArtist] = musicItem.publisherTitle
          nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = musicItem.runningDurationInSeconds
          
          // Set artwork
          do {
            let (artworkData, _) = try await URLSession.shared.data(
              from: URL(string: musicItem.largestThumbnail)!
            )
            let newImageSize = CGSize(width: 500, height: 500)
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(
              boundsSize: newImageSize
            ) { size in
              let newWidth = newImageSize.width
              let image = UIImage(data: artworkData)!
              let oldWidth = image.size.width
              let scaleFactor = newImageSize.width / oldWidth
              let newHeight = oldWidth * scaleFactor
              
              let rect = CGRect(
                origin: .zero,
                size: CGSize(width: newWidth, height: newHeight)
              )
              UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
              image.draw(in: rect)
              let newImage = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()
              return newImage!
            }
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = progress
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
          } catch {
            Self.logger.error("Error getting artwork data for \(musicItem.title)")
          }
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func setupRemoteCommandCenter() {
    let rcc = MPRemoteCommandCenter.shared()
    rcc.pauseCommand.isEnabled = true
    rcc.pauseCommand.addTarget { [weak self] _ in
      self?.pause()
      return .success
    }
    
    rcc.playCommand.isEnabled = true
    rcc.playCommand.addTarget { [weak self] _ in
      self?.resume()
      return .success
    }
    
    rcc.nextTrackCommand.isEnabled = true
    rcc.nextTrackCommand.addTarget { [weak self] _ in
      self?.seekToNextMusicItem()
      return .success
    }
    
    rcc.previousTrackCommand.isEnabled = true
    rcc.previousTrackCommand.addTarget { [weak self] _ in
      self?.seekToPreviousMusicItem()
      return .success
    }
    rcc.changePlaybackPositionCommand.isEnabled = true
    rcc.changePlaybackPositionCommand.addTarget { [weak self] event in
      guard let position = event as? MPChangePlaybackPositionCommandEvent else {
        return .commandFailed
      }
      self?.seekToTime(
        seconds: Int(position.positionTime)) {
          
        }
      return .success
    }
  }
}

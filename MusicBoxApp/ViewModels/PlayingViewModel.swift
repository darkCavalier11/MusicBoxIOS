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
}

class MusicPlayingViewModel: NSObject, PlayingViewModel {
  private lazy var musicPlayingStatusRelay: BehaviorRelay<MusicPlayingStatus> = .init(value: .unknown)
  private let selectedMusicItemRelay = BehaviorRelay<MusicItem?>(value: nil)
  private let player = AVQueuePlayer()
  private let musicBox: MusicBox
  
  init(musicBox: MusicBox) {
    self.musicBox = musicBox
  }
  
  var selectedMusicItem: Observable<MusicItem?> {
    selectedMusicItemRelay.asObservable()
  }
  
  var musicPlayingStatus: Observable<MusicPlayingStatus> {
    musicPlayingStatusRelay.asObservable()
  }
  
  func playMusicItem(musicItem: MusicItem) {
    musicPlayingStatusRelay.accept(.readyToPlay)
    selectedMusicItemRelay.accept(musicItem)
    
    Task {
      guard let streamingURL = await musicBox.musicSession.getMusicStreamingURL(musicId: musicItem.musicId) else {
        // TODO: - Handle by showing a toast
        return
      }
      let item = AVPlayerItem(url: streamingURL)
      player.insert(.init(url: streamingURL), after: nil)
      player.play()
      
      player
        .rx
        
    }
  }
}

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

protocol PlayingViewModel {
  var musicPlayingStatus: Observable<MusicPlayingStatus> { get }
  var selectedMusicItem: Observable<MusicItem?> { get }
  
  func playMusicItem(musicItem: MusicItem)
}

class MusicPlayingViewModel: PlayingViewModel {
  private lazy var musicPlayingStatusRelay: BehaviorRelay<MusicPlayingStatus> = .init(value: .idle)
  private let selectedMusicItemRelay = BehaviorRelay<MusicItem?>(value: nil)
  
  var selectedMusicItem: Observable<MusicItem?> {
    selectedMusicItemRelay.asObservable()
  }
  
  var musicPlayingStatus: Observable<MusicPlayingStatus> {
    musicPlayingStatusRelay.asObservable()
  }
  
  func playMusicItem(musicItem: MusicItem) {
    musicPlayingStatusRelay.accept(.initialising)
    selectedMusicItemRelay.accept(musicItem)
  }
}

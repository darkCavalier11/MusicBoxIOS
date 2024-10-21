//
//  MusicViewModel.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 21/10/24.
//

import Foundation
import MusicBox
import RxSwift
import RxCocoa

protocol MusicViewModel {
  var isFetchingMusicList: Observable<Bool> { get }
  func getMusicList(query: MusicListQueryType) -> Observable<[MusicItem]>
}

enum MusicListQueryType {
  case defaultMusicList
  case withSearchQuery(query: String)
}

final class HomeMusicViewModel: MusicViewModel {
  let mb = MusicBox()
  private let isFetchingMusicListRelay = BehaviorRelay(value: false)
  
  var isFetchingMusicList: Observable<Bool> {
    isFetchingMusicListRelay.asObservable()
  }
  
  func getMusicList(query: MusicListQueryType) -> Observable<[MusicItem]> {
    Observable.create { observer in
      let task = Task { [weak self] in
        guard let self = self else { return }
        self.isFetchingMusicListRelay.accept(true)
        switch query {
        case .defaultMusicList:
          let musicList = await self.mb.musicSession.getHomeScreenMusicList()
          observer.onNext(musicList)
          
        case .withSearchQuery(query: let query):
          let musicList = await self.mb.musicSession.getMusicSearchResults(query: query)
          observer.onNext(musicList)
        }
        self.isFetchingMusicListRelay.accept(false)
      }
      return Disposables.create {
        task.cancel()
      }
    }
  }
}

extension MusicItem: Sendable {}

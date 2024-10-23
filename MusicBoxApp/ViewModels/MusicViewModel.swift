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

protocol MusicViewModel: AnyObject {
  var isFetchingMusicList: Observable<Bool> { get }
  var musicItemList: Observable<[MusicItem]> { get }
  func setMusicListQuery(_ query: MusicListQueryType)
}

enum MusicListQueryType {
  case defaultMusicList
  case withSearchQuery(query: String)
}

final class HomeMusicViewModel: MusicViewModel {
  let mb = MusicBox()
  private let isFetchingMusicListRelay = BehaviorRelay(value: false)
  private let musicListQueryTypeRelay = BehaviorRelay(value: MusicListQueryType.defaultMusicList)
  
  var isFetchingMusicList: Observable<Bool> {
    isFetchingMusicListRelay.asObservable()
  }
  
  func setMusicListQuery(_ query: MusicListQueryType) {
    musicListQueryTypeRelay.accept(query)
  }
  
  var musicItemList: Observable<[MusicItem]> {
    musicListQueryTypeRelay
      .flatMapLatest { [weak self] query in
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
            let musicList = await self.mb.musicSession.getMusicSearchResults(query: "one direction")
            observer.onNext(musicList)
            self.isFetchingMusicListRelay.accept(false)
          }
          return Disposables.create {
            task.cancel()
          }
        }
      }
  }
}

extension MusicItem: Sendable {
  public static var defaultAspectRatio: CGFloat  {
    360/202
  }
}

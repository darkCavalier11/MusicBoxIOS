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
import UIKit

protocol BrowsingViewModel: AnyObject {
  var isFetchingMusicList: Observable<Bool> { get }
  var musicItemList: Observable<[MusicItem]> { get }
  var playingViewModel: PlayingViewModel { get }
  func addMusicToPlaylist(controller: UIViewController, musicItem: MusicItem)
  func setMusicListQuery(_ query: MusicListQueryType) 
}

enum MusicPlayingStatus {
  case playing
  case paused
  case unknown
  case readyToPlay
  case error
}

enum MusicListQueryType: Equatable {
  case defaultMusicList
  case withSearchQuery(query: String)
  case playlist(id: UUID)
  case nextMusicItems(currentMusicId: String)
}

final class MusicBrowsingViewModel: BrowsingViewModel {
  private let musicBox: MusicBox
  private let coreDataStack: CoreDataStack
  let playingViewModel: PlayingViewModel
  
  init(
    musicBox: MusicBox,
    coreDataStack: CoreDataStack,
    playingViewModel: PlayingViewModel
  ) {
    self.musicBox = musicBox
    self.coreDataStack = coreDataStack
    self.playingViewModel = playingViewModel
  }
  
  private let isFetchingMusicListRelay = BehaviorRelay(value: false)
  private let musicListQueryTypeRelay = BehaviorRelay<MusicListQueryType?>(value: nil)
  
  

  private lazy var playlistService = MusicPlaylistServices(
    coreDataStack: coreDataStack,
    context: coreDataStack.managedObjectContext
  )
  
  var isFetchingMusicList: Observable<Bool> {
    isFetchingMusicListRelay
      .asObservable()
  }
  
  func setMusicListQuery(_ query: MusicListQueryType) {
    musicListQueryTypeRelay.accept(query)
  }
  
  lazy var musicItemList: Observable<[MusicItem]> = {
    musicListQueryTypeRelay
      .flatMapLatest { [weak self] query in
        return Observable.create { observer in
          let task = Task { [weak self] in
            guard let self = self else { return }
            self.isFetchingMusicListRelay.accept(true)
            
            switch query {
            case .defaultMusicList:
              let musicList = await self.musicBox.musicSession.getHomeScreenMusicList()
              observer.onNext(musicList)
              self.isFetchingMusicListRelay.accept(false)
              
            case .withSearchQuery(query: let query):
              let musicList = await self.musicBox.musicSession.getMusicSearchResults(query: query)
              observer.onNext(musicList)
              self.isFetchingMusicListRelay.accept(false)
              
            case .playlist(id: let id):
              let model = playlistService.getMusicPlaylistById(id)
              let musicItems = model?.musicItems?.allObjects as? [MusicItemModel]
              guard let musicItems else { return }
              observer.onNext(musicItems.map {
                MusicItem(
                  title: $0.title ?? "",
                  publisherTitle: $0.publisherTitle ?? "-",
                  runningDurationInSeconds: Int($0.runningDurationInSeconds),
                  musicId: $0.musicId ?? "",
                  smallestThumbnail: $0.smallestThumbnail,
                  largestThumbnail: $0.largestThumbnail
                )
              })
              self.isFetchingMusicListRelay.accept(false)
            case .nextMusicItems(currentMusicId: let musicId):
              let musicList = await musicBox.musicSession.getNextSuggestedMusicItems(musicId: musicId)
              observer.onNext(musicList)
              self.isFetchingMusicListRelay.accept(false)
            case .none:
              break
            }
          }
          return Disposables.create {
            task.cancel()
          }
        }
      }
      .share(replay: 1)
  }()
    

  
  func addMusicToPlaylist(controller: UIViewController, musicItem: MusicItem) {
    let addToPlaylistVC = AddToPlaylistViewController()
    addToPlaylistVC.musicItem = musicItem
    controller.present(addToPlaylistVC, animated: true)
  }
}

extension MusicItem: Sendable {
  public static var defaultAspectRatio: CGFloat  {
    360/202
  }
}

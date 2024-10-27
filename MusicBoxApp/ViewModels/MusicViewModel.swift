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

protocol MusicViewModel: AnyObject {
  var isFetchingMusicList: Observable<Bool> { get }
  var musicItemList: Observable<[MusicItem]> { get }
  func setMusicListQuery(_ query: MusicListQueryType)
  func dismissMusicItem(musicPlaylistModel: MusicPlaylistModel, musicItem: MusicItem)
  func addMusicToPlaylist(controller: UINavigationController, musicItem: MusicItem)
  func startDowloadingMusic(_ musicItem: MusicItem)
}

enum MusicListQueryType {
  case defaultMusicList
  case withSearchQuery(query: String)
  case playlist(id: UUID)
}

final class MusicListViewModel: MusicViewModel {
  let mb = MusicBox()
  private let isFetchingMusicListRelay = BehaviorRelay(value: false)
  private let musicListQueryTypeRelay = BehaviorRelay(value: MusicListQueryType.defaultMusicList)
  private lazy var coreDataStack = CoreDataStack()
  private lazy var playlistService = MusicPlaylistServices(
    coreDataStack: coreDataStack,
    context: coreDataStack.managedObjectContext
  )
  
  var isFetchingMusicList: Observable<Bool> {
    isFetchingMusicListRelay
      .share(replay: 1)
      .asObservable()
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
            }
            
            self.isFetchingMusicListRelay.accept(false)
          }
          return Disposables.create {
            task.cancel()
          }
        }
      }
  }
  
  func addMusicToPlaylist(controller: UINavigationController, musicItem: MusicItem) {
    let addToPlaylistVC = AddToPlaylistViewController()
    addToPlaylistVC.musicItem = musicItem
    controller.present(addToPlaylistVC, animated: true)
  }
  
  func startDowloadingMusic(_ musicItem: MusicItem) {
    // TODO: -
  }
  
  func dismissMusicItem(musicPlaylistModel: MusicPlaylistModel, musicItem: MusicItem) {
    playlistService.removeFromPlaylist(model: musicPlaylistModel, musicItemModel: musicItem)
    
  }
}

extension MusicItem: Sendable {
  public static var defaultAspectRatio: CGFloat  {
    360/202
  }
}

//
//  Container+extension.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 30/10/24.
//

import Swinject
import MusicBox

extension Container {
  static var sharedContainer: Container = {
    let container = Container()
    container.register(CoreDataStack.self) { _ in
      CoreDataStack()
    }
    .inObjectScope(.container)
    container.register(MusicBox.self) { _ in
      MusicBox()
    }
    .inObjectScope(.container)
    container.register(PlayingViewModel.self) { _ in
      let musicBox = container.resolve(MusicBox.self)!
      return MusicPlayingViewModel(
        musicBox: musicBox
      )
    }
    .inObjectScope(.container)
    container.register(DownloadViewModel.self) { _ in
      let musicBox = container.resolve(MusicBox.self)!
      let coreDataStack = container.resolve(CoreDataStack.self)!
      let playingViewModel = container.resolve(PlayingViewModel.self)!
      return MusicDownloadViewModel(
        musicBox: musicBox,
        coreDataStack: coreDataStack,
        playingViewModel: playingViewModel
      )
    }
    .inObjectScope(.container)
    container.register(BrowsingViewModel.self) { r in
      let musicBox = r.resolve(MusicBox.self)!
      let coreDataStack = r.resolve(CoreDataStack.self)!
      let playingViewModel = r.resolve(PlayingViewModel.self)!
      return MusicBrowsingViewModel(
        musicBox: musicBox,
        coreDataStack: coreDataStack,
        playingViewModel: playingViewModel
      )
    }
    container.register(SearchViewModel.self) { r in
      let musicBox = r.resolve(MusicBox.self)!
      return MusicSearchViewModel(musicBox: musicBox)
    }
    return container
  }()
}

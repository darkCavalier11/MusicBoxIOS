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
      MusicPlayingViewModel()
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

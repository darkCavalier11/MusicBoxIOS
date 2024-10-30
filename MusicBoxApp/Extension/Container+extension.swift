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
    container.register(MusicBox.self) { _ in
      MusicBox()
    }
    container.register(PlayingViewModel.self) { _ in
      MusicPlayingViewModel()
    }
    return container
  }()
}

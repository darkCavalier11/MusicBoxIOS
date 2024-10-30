//
//  Container+extension.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 30/10/24.
//

import Swinject
import MusicBox

extension Container {
  static var shared: Container = {
    let container = Container()
    container.register(CoreDataStack.self) { _ in
      CoreDataStack()
    }
    
    return container
  }()
}

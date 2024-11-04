//
//  MusicItemModelServices.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 04/11/24.
//

import CoreData
import MusicBox

final class MusicItemModelServices {
  let coreDataStack: CoreDataStack
  let context: NSManagedObjectContext
  
  init(coreDataStack: CoreDataStack, context: NSManagedObjectContext) {
    self.coreDataStack = coreDataStack
    self.context = context
  }

  func insertNewMusicItemModelWithLocalStorage(
    musicItem: MusicItem,
    withLocalStorageURL url: URL
  ) {
    let model = MusicItemModel(context: context)
    model.title = musicItem.title
    model.runningDurationInSeconds = Int64(musicItem.runningDurationInSeconds)
    model.publisherTitle = musicItem.publisherTitle
    model.largestThumbnail = musicItem.largestThumbnail
    model.smallestThumbnail = musicItem.smallestThumbnail
    model.musicId = musicItem.musicId
    model.localStorageURL = url
    coreDataStack.saveContext()
  }
  
  func removeMusicItemModel(
    model: MusicItemModel
  ) {
    context.delete(model)
    coreDataStack.saveContext()
  }
}

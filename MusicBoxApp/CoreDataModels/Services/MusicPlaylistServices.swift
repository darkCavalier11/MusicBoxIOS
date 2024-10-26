//
//  MusicPlaylistServices.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 25/10/24.
//

import CoreData
import MusicBox

final class MusicPlaylistServices {
  let coreDataStack: CoreDataStack
  let context: NSManagedObjectContext
  
  init(coreDataStack: CoreDataStack, context: NSManagedObjectContext) {
    self.coreDataStack = coreDataStack
    self.context = context
  }
  
  func addNewPlaylist(
    title: String,
    musicItems: [MusicItem]
  ) {
    let musicPlaylistModel = MusicPlaylistModel(context: context)
    musicPlaylistModel.title = title
    musicPlaylistModel.id = UUID()
    
    musicItems.forEach { item in
      let model = MusicItemModel(context: context)
      model.title = item.title
      model.runningDurationInSeconds = Int64(item.runningDurationInSeconds)
      model.publisherTitle = item.publisherTitle
      model.largestThumbnail = item.largestThumbnail
      model.smallestThumbnail = item.smallestThumbnail
      model.musicId = item.musicId
      musicPlaylistModel.addToMusicItems(model)
    }
    
    coreDataStack.saveContext()
  }
  
  func removePlaylist(
    model: MusicPlaylistModel
  ) {
    context.delete(model)
    coreDataStack.saveContext()
  }
  
  func addToPlaylist(
    model: MusicPlaylistModel,
    musicItem: MusicItem
  ) {
    let musicItemModel = MusicItemModel(context: context)
    model.addToMusicItems(musicItemModel)
    coreDataStack.saveContext()
  }
  
  func removeFromPlaylist(
    model: MusicPlaylistModel,
    musicItem: MusicItemModel
  ) {
    model.addToMusicItems(musicItem)
    coreDataStack.saveContext()
  }
}

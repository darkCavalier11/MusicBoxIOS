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
  
  func addPlaylist(
    title: String,
    musicItems: [MusicItem]
  ) {
    let musicPlaylistModel = MusicPlaylistModel(context: context)
    musicPlaylistModel.title = title
    musicPlaylistModel.id = UUID()
    
    musicItems.forEach { item in
      guard let model = MusicItemModel(item, context: context) else {
        return
      }
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
    guard let musicItemModel = MusicItemModel(musicItem, context: context) else { return }
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

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
  
  func getMusicPlaylistById(
    _ id: UUID
  ) -> MusicPlaylistModel? {
    let request = MusicPlaylistModel.fetchRequest()
    request.predicate = NSPredicate(
      format: "%K == %@",
      (\MusicPlaylistModel.id)._kvcKeyPathString!,
      id as NSUUID
    )
    
    guard let musicModel = try? context.fetch(request), musicModel.count > 0 else { return nil }
    return musicModel.first
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
  ) -> Bool {
    let musicItemModel = MusicItemModel(context: context)
    musicItemModel.title = musicItem.title
    musicItemModel.runningDurationInSeconds = Int64(musicItem.runningDurationInSeconds)
    musicItemModel.publisherTitle = musicItem.publisherTitle
    musicItemModel.largestThumbnail = musicItem.largestThumbnail
    musicItemModel.smallestThumbnail = musicItem.smallestThumbnail
    musicItemModel.musicId = musicItem.musicId
    let alreadyExist = (model.musicItems as? Set<MusicItemModel>)?.contains(where: { $0.musicId == musicItem.musicId })
    if alreadyExist == true {
      return false
    }
    model.addToMusicItems(musicItemModel)
    coreDataStack.saveContext()
    return true
  }
  
  func removeFromPlaylist(
    model: MusicPlaylistModel,
    musicItemModel: MusicItem
  ) {
    guard let musicItemModel = model.musicItems?.first(where: { item in
      guard let currentModel = item as? MusicItemModel else { return false }
      return currentModel.musicId == musicItemModel.musicId
    }) as? MusicItemModel else { return }
    model.removeFromMusicItems(musicItemModel)
    coreDataStack.saveContext()
  }
}

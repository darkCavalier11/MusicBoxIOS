//
//  MusicItemModel+CoreDataClass.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 24/10/24.
//
//

import Foundation
import CoreData
import MusicBox


public class MusicItemModel: NSManagedObject {
  init?(_ musicItem: MusicItem, context: NSManagedObjectContext) {
    guard let entity = NSEntityDescription.entity(forEntityName: "MusicItemModel", in: context) else {
      return nil
    }
    super.init(entity: entity, insertInto: context)
    self.smallestThumbnail = musicItem.smallestThumbnail
    self.publisherTitle = musicItem.publisherTitle
    self.largestThumbnail = musicItem.largestThumbnail
    self.musicId = musicItem.musicId
    self.title = musicItem.title
    self.runningDurationInSeconds = Int64(musicItem.runningDurationInSeconds)
  }
}

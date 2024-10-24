//
//  MusicPlaylistModel+CoreDataClass.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 24/10/24.
//
//

import Foundation
import CoreData
import os


public class MusicPlaylistModel: NSManagedObject {
  static private let logger = Logger(subsystem: "com.youtube.interface", category: "CoreData.UserInternalData")
  
  public var totalDurationInSeconds: Int {
    guard let musicItems = Array(arrayLiteral: musicItems) as? [MusicItemModel] else { return 0 }
    return musicItems.reduce(0) { $0 + Int($1.runningDurationInSeconds) }
  }
  
  public var top3ArtistNames: [String] {
    var top3ArtistNames = Set<String>()
    guard let musicItems = Array(arrayLiteral: musicItems) as? [MusicItemModel] else { return [] }
    for item in musicItems {
      if top3ArtistNames.count >= 3 { break }
      top3ArtistNames.insert(item.publisherTitle ?? "-")
    }
    return Array(top3ArtistNames).sorted()
  }
  
  public var top3ThumbnailURLs: [URL] {
    var top3ThumbnailURLs: [URL] = []
    guard let musicItems = Array(arrayLiteral: musicItems) as? [MusicItemModel] else { return [] }
    for item in musicItems {
      if top3ThumbnailURLs.count == 3 { break }
      guard item.smallestThumbnail != nil,
            let thumbnailURL = URL(string: item.smallestThumbnail!) else {
        continue
      }
      top3ThumbnailURLs.append(thumbnailURL)
    }
    return top3ThumbnailURLs
  }
  
  public func deletePlaylist(_ playlist: MusicPlaylistModel, context: NSManagedObjectContext) {
    context.delete(playlist)
    Self.logger.log("Deleting playlist: \(playlist.title ?? "-")")
    try? context.save()
  }
}

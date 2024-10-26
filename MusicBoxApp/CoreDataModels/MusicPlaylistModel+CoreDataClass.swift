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
  static private let logger = Logger(subsystem: "com.MusicBoxApp.CoreData", category: "MusicPlaylistModel")
  
  public var totalDurationInSeconds: Int {
    guard let musicItems = musicItems?.allObjects as? [MusicItemModel] else { return 0 }
    return musicItems.reduce(0) { $0 + Int($1.runningDurationInSeconds) }
  }
  
  public var artistDesc: String {
    var artistSet = Set<String>()
    guard let musicItems = musicItems?.allObjects as? [MusicItemModel] else { return "No Artists" }
    for item in musicItems {
      artistSet.insert(item.publisherTitle ?? "-")
    }
    let artists = Array(artistSet)
    if artists.count == 1 {
      return artists[0]
    } else if artists.count == 2 {
      return artists[0] + ", " + artists[1]
    } else if artists.count == 3 {
      return artists[0] + ", " + artists[1] + ", " + artists[2]
    }
    return artists[0] + ", " + artists[1] + ", " + artists[2] + " and others."
  }
  
  public var top3ThumbnailURLs: [URL] {
    var top3ThumbnailURLs: [URL] = []
    guard let musicItems = musicItems?.allObjects as? [MusicItemModel] else { return [] }
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
}

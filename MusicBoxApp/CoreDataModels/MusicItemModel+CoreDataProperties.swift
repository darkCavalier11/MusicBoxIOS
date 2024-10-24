//
//  MusicItemModel+CoreDataProperties.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 24/10/24.
//
//

import Foundation
import CoreData


extension MusicItemModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MusicItemModel> {
        return NSFetchRequest<MusicItemModel>(entityName: "MusicItemModel")
    }

    @NSManaged public var largestThumbnail: String?
    @NSManaged public var musicId: String?
    @NSManaged public var smallestThumbnail: String?
    @NSManaged public var publisherTitle: String?
    @NSManaged public var runningDurationInSeconds: Int64
    @NSManaged public var title: String?

}

extension MusicItemModel : Identifiable {

}

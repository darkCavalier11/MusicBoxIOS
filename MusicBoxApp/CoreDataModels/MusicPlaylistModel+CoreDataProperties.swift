//
//  MusicPlaylistModel+CoreDataProperties.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 24/10/24.
//
//

import Foundation
import CoreData


extension MusicPlaylistModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MusicPlaylistModel> {
        return NSFetchRequest<MusicPlaylistModel>(entityName: "MusicPlaylistModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var musicItems: NSSet?

}

// MARK: Generated accessors for musicItems
extension MusicPlaylistModel {

    @objc(addMusicItemsObject:)
    @NSManaged public func addToMusicItems(_ value: MusicItemModel)

    @objc(removeMusicItemsObject:)
    @NSManaged public func removeFromMusicItems(_ value: MusicItemModel)

    @objc(addMusicItems:)
    @NSManaged public func addToMusicItems(_ values: NSSet)

    @objc(removeMusicItems:)
    @NSManaged public func removeFromMusicItems(_ values: NSSet)

}

extension MusicPlaylistModel : Identifiable {

}

//
//  MusicPlaylistModelCoreDataTests.swift
//  MusicBoxAppTests
//
//  Created by Sumit Pradhan on 25/10/24.
//

import XCTest
import CoreData
@testable import MusicBoxApp
import MusicBox

class TestCoreDataStack: CoreDataStack {
  override init() {
    super.init()
    
    let persistentStoreDescription =
    NSPersistentStoreDescription()
    persistentStoreDescription.type = NSInMemoryStoreType
    
    let container = NSPersistentContainer(
      name: "MusicBoxApp"
    )
    
    container.persistentStoreDescriptions =
    [persistentStoreDescription]
    
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        fatalError(
          "Unresolved error \(error), \(error.userInfo)")
      }
    }
    
    Self.storeContainer = container
  }
}


class TestPlaylistModelCoreDataTests: XCTestCase {
  var coreDataStack: TestCoreDataStack!
  var playlistService: MusicPlaylistServices!
  
  lazy var musicItem1: MusicItem = {
    let musicItem = MusicItem(title: "Test Music Item 1", publisherTitle: "Test Publisher 1", runningDurationInSeconds: 100, musicId: "A")
    return musicItem
  }()
  lazy var musicItem2: MusicItem = {
    let musicItem = MusicItem(title: "Test Music Item 2", publisherTitle: "Test Publisher 2", runningDurationInSeconds: 250, musicId: "B")
    return musicItem
  }()
  lazy var musicItem3: MusicItem = {
    let musicItem = MusicItem(title: "Test Music Item 3", publisherTitle: "Test Publisher 3", runningDurationInSeconds: 250, musicId: "C")
    return musicItem
  }()
  
  override func setUpWithError() throws {
    coreDataStack = TestCoreDataStack()
    playlistService = MusicPlaylistServices(coreDataStack: coreDataStack, context: coreDataStack.managedObjectContext)
  }
    
  override func tearDownWithError() throws {
    coreDataStack = nil
    playlistService = nil
  }
  
  func testAddPlaylist() throws {
    let request = MusicPlaylistModel.fetchRequest()
    let result = try? coreDataStack.managedObjectContext.fetch(request)
    XCTAssertNotNil(result)
    XCTAssert(result!.isEmpty)
    
    playlistService.addNewPlaylist(title: "Test Playlist", musicItems: [musicItem1, musicItem2, musicItem3])
    
    let fetchedPlaylist = try? coreDataStack.managedObjectContext.fetch(request)
    XCTAssert(fetchedPlaylist?.isEmpty == false)
    XCTAssert(fetchedPlaylist?.first?.id != nil)
    XCTAssert(fetchedPlaylist?.first?.title == "Test Playlist")
    XCTAssert(fetchedPlaylist?.first?.musicItems?.count == 3)
  }
  
  func testRemovePlaylist() throws {
    playlistService.addNewPlaylist(title: "Test Playlist", musicItems: [musicItem1, musicItem2, musicItem3])
    let request = MusicPlaylistModel.fetchRequest()
    let allPlaylists = try? coreDataStack.managedObjectContext.fetch(request)
    XCTAssert(allPlaylists?.count == 1)
    playlistService.removePlaylist(model: allPlaylists!.first!)
    let newPlaylists = try? coreDataStack.managedObjectContext.fetch(request)
    XCTAssert(newPlaylists?.isEmpty == true)
  }
  
  func testAddToPlaylist() throws {
    playlistService.addNewPlaylist(title: "Test Playlist", musicItems: [musicItem1, musicItem2, musicItem3])
    let request = MusicPlaylistModel.fetchRequest()
    let allPlaylists = try? coreDataStack.managedObjectContext.fetch(request)
    XCTAssert(allPlaylists?.count == 1)
    
    let model = allPlaylists!.first!
    let addedDuplicate = playlistService.addToPlaylist(model: model, musicItem: musicItem1)
    XCTAssert(addedDuplicate == false)
    
    let newMusicItem = MusicItem(title: "Test Music Item 4", publisherTitle: "Test Publisher 4", runningDurationInSeconds: 50, musicId: "D")
    let addedNewMusicItem = playlistService.addToPlaylist(model: model, musicItem: newMusicItem)
    XCTAssert(addedNewMusicItem)
  }
  
  func testRemoveFromPlaylist() throws {
    playlistService.addNewPlaylist(title: "Test Playlist", musicItems: [musicItem1, musicItem2, musicItem3])
    let request = MusicPlaylistModel.fetchRequest()
    let allPlaylists = try? coreDataStack.managedObjectContext.fetch(request)
    XCTAssert(allPlaylists?.count == 1)
    
    let model = allPlaylists!.first!
    let musicItemModels = allPlaylists!.first!.musicItems!.allObjects as! [MusicItemModel]
    playlistService.removeFromPlaylist(model: model, musicItemModel: musicItemModels.first!)
    let newPlaylists = try? coreDataStack.managedObjectContext.fetch(request)
    XCTAssert(newPlaylists?.count == 1)
    XCTAssert(newPlaylists!.first!.musicItems?.count == 2)
  }
}
    

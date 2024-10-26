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
  var playlistModel: MusicPlaylistModel!
  
  lazy var musicItem1: MusicItemModel = {
    let musicItem = MusicItem(title: "Test Music Item 1", publisherTitle: "Test Publisher 1", runningDurationInSeconds: 100, musicId: "A")
    let m = MusicItemModel(musicItem, context: coreDataStack.managedObjectContext)!
    return m
  }()
  lazy var musicItem2: MusicItemModel = {
    let musicItem = MusicItem(title: "Test Music Item 2", publisherTitle: "Test Publisher 2", runningDurationInSeconds: 250, musicId: "B")
    let m = MusicItemModel(musicItem, context: coreDataStack.managedObjectContext)!
    return m
  }()
  lazy var musicItem3: MusicItemModel = {
    let musicItem = MusicItem(title: "Test Music Item 3", publisherTitle: "Test Publisher 3", runningDurationInSeconds: 250, musicId: "C")
    let m = MusicItemModel(musicItem, context: coreDataStack.managedObjectContext)!
    return m
  }()
  
  override func setUpWithError() throws {
    coreDataStack = TestCoreDataStack()
  }
    
  override func tearDownWithError() throws {
    coreDataStack = nil
  }
  
  func testAddPlaylist() throws {
    playlistModel = MusicPlaylistModel(context: coreDataStack.managedObjectContext)
    let request = MusicPlaylistModel.fetchRequest()
    let result = try? coreDataStack.managedObjectContext.fetch(request)
    let nonNullResults = result?.compactMap { $0.id != nil ? $0 : nil }
    XCTAssert(nonNullResults!.isEmpty)
    
    playlistModel.id = UUID()
    playlistModel.title = "Test Playlist"
    playlistModel.addToMusicItems(musicItem1)
    playlistModel.addToMusicItems(musicItem2)
    playlistModel.addToMusicItems(musicItem3)
    
    coreDataStack.saveContext()
    
    let fetchedPlaylist = try? coreDataStack.managedObjectContext.fetch(request)
    XCTAssert(fetchedPlaylist?.isEmpty == false)
    XCTAssert(fetchedPlaylist?.first?.id != nil)
    XCTAssert(fetchedPlaylist?.first?.title == "Test Playlist")
    XCTAssert(fetchedPlaylist?.first?.musicItems?.count == 3)
  }
  
  func testRemovePlaylist() throws {
    playlistModel = MusicPlaylistModel(context: coreDataStack.managedObjectContext)
    let request = MusicPlaylistModel.fetchRequest()
    let result = try? coreDataStack.managedObjectContext.fetch(request)
    let nonNullResults = result?.compactMap { $0.id != nil ? $0 : nil }
    XCTAssert(nonNullResults!.isEmpty)
    
    playlistModel.id = UUID()
    playlistModel.title = "Test Playlist"
    playlistModel.addToMusicItems(musicItem1)
    playlistModel.addToMusicItems(musicItem2)
    playlistModel.addToMusicItems(musicItem3)
    
    coreDataStack.saveContext()
    
    coreDataStack.managedObjectContext.delete(playlistModel)
    
    let newResult = try? coreDataStack.managedObjectContext.fetch(request)
    let newNonNullResults = newResult?.compactMap { $0.id != nil ? $0 : nil }
    XCTAssert(newNonNullResults!.isEmpty)
  }
  
  func testAddToPlaylist() throws {
    playlistModel = MusicPlaylistModel(context: coreDataStack.managedObjectContext)
    let request = MusicPlaylistModel.fetchRequest()
    let result = try? coreDataStack.managedObjectContext.fetch(request)
    let nonNullResults = result?.compactMap { $0.id != nil ? $0 : nil }
    XCTAssert(nonNullResults!.isEmpty)
    
    playlistModel.id = UUID()
    playlistModel.title = "Test Playlist"
    coreDataStack.saveContext()
    var newResult = try? coreDataStack.managedObjectContext.fetch(request)
    var newNonNullResults = newResult?.compactMap { $0.id != nil ? $0 : nil }
    XCTAssert(newNonNullResults!.count == 1)
    XCTAssert(newNonNullResults!.first?.musicItems?.count == 0)
    
    playlistModel.addToMusicItems(musicItem1)
    XCTAssert(playlistModel.musicItems?.count == 1)
    newResult = try? coreDataStack.managedObjectContext.fetch(request)
    newNonNullResults = newResult?.compactMap { $0.id != nil ? $0 : nil }
    XCTAssert(newNonNullResults!.count == 1)
    XCTAssert(newNonNullResults!.first?.musicItems?.count == 1)
  }
  
  func testRemoveFromPlaylist() throws {
    playlistModel = MusicPlaylistModel(context: coreDataStack.managedObjectContext)
    let request = MusicPlaylistModel.fetchRequest()
    let result = try? coreDataStack.managedObjectContext.fetch(request)
    let nonNullResults = result?.compactMap { $0.id != nil ? $0 : nil }
    XCTAssert(nonNullResults!.isEmpty)
    
    playlistModel.id = UUID()
    playlistModel.title = "Test Playlist"
    playlistModel.addToMusicItems(musicItem1)
    playlistModel.addToMusicItems(musicItem2)
    
    coreDataStack.saveContext()
    
    var newResult = try? coreDataStack.managedObjectContext.fetch(request)
    var newNonNullResults = newResult?.compactMap { $0.id != nil ? $0 : nil }
    XCTAssert(newNonNullResults!.count == 1)
    XCTAssert(newNonNullResults!.first?.musicItems?.count == 2)
    
    playlistModel.removeFromMusicItems(musicItem1)
    XCTAssert(playlistModel.musicItems?.count == 1)
    newResult = try? coreDataStack.managedObjectContext.fetch(request)
    newNonNullResults = newResult?.compactMap { $0.id != nil ? $0 : nil }
    XCTAssert(newNonNullResults!.count == 1)
    XCTAssert(newNonNullResults!.first?.musicItems?.count == 1)
    let allMusicItems = newNonNullResults?.first?.musicItems?.allObjects as? [MusicItemModel]
    XCTAssertNotNil(allMusicItems)
    XCTAssert(allMusicItems?.first == musicItem2)
  }
}
    

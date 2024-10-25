//
//  CoreDataStack.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 24/10/24.
//


import Foundation
import CoreData
import os

fileprivate let logger = Logger(subsystem: "com.MusicBoxApp.Core", category: "CoreData")

public class CoreDataStack {
  static private let modelName = "MusicBoxApp"
  
  init() {}
  
  static var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: modelName)
    container.loadPersistentStores { _, error in
      if let error {
        logger.error("Failed to load persistent stores: \(error)")
      }
    }
    return container
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    Self.storeContainer.viewContext
  }()
  
  func saveContext() {
    guard managedObjectContext.hasChanges else { return }
    do {
      _ = try managedObjectContext.save()
    } catch let error as NSError {
      logger.error("Unresolved error \(error), \(error.userInfo)")
    }
  }
}

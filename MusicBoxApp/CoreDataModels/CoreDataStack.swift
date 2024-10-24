//
//  CoreDataStack.swift
//  MusicBoxApp
//
//  Created by Sumit Pradhan on 24/10/24.
//


import Foundation
import CoreData
import os

fileprivate let logger = Logger(subsystem: "com.youtube.interface", category: "CoreDataStack")

public class CoreDataStack {
  private let modelName: String
  
  init(modelName: String) {
    self.modelName = modelName
  }
  
  private lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: modelName)
    container.loadPersistentStores { _, error in
      if let error {
        logger.error("Failed to load persistent stores: \(error)")
      }
    }
    return container
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    self.storeContainer.viewContext
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

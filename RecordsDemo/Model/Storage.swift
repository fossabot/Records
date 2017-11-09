//
//  Storage.swift
//  Database
//
//  Created by Robert Nash on 21/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import Foundation
import CoreData
import Database

class Storage {
  
  let persistentContainer: NSPersistentContainer
  
  static let sharedInstance = Storage()
  
  private init() {
    persistentContainer = Storage.load()
  }
  
  private static func load() -> NSPersistentContainer {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: Database.Event.self)])!
    let container = NSPersistentContainer(name: "Model", managedObjectModel: managedObjectModel)
    container.loadPersistentStores { (_, _) in }
    return container
  }

}

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

final class Storage {
  
  static func load() -> NSPersistentContainer {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: Database.Event.self)])!
    let container = NSPersistentContainer(name: "Model", managedObjectModel: managedObjectModel)
    let desc = NSPersistentStoreDescription()
    desc.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [desc]
    container.loadPersistentStores { (_, _) in }
    return container
  }
  
}

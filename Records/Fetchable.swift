//
//  DuplicationPreventable.swift
//  Records
//
//  Created by Robert Nash on 20/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import Foundation
import CoreData

public protocol Fetchable {
  static func fetchAll<T: NSManagedObject>(in context: NSManagedObjectContext) throws -> [T]
  static func fetchAll<T: NSManagedObject>(withPredicate predicate: NSPredicate?, in context: NSManagedObjectContext) throws -> [T]
  static func fetchFirst<T: NSManagedObject>(in context: NSManagedObjectContext) throws -> T?
  static func fetchFirst<T: NSManagedObject>(in context: NSManagedObjectContext, sortedBy sort: [NSSortDescriptor]?) throws -> T?
  static func fetchFirst<T: NSManagedObject>(withPredicate predicate: NSPredicate?, in context: NSManagedObjectContext) throws -> T?
  static func fetchFirst<T: NSManagedObject>(withPredicate predicate: NSPredicate?, in context: NSManagedObjectContext, sortedBy sort: [NSSortDescriptor]?) throws -> T?
}

public extension Fetchable {
  
  static func fetchAll<T: NSManagedObject>(in context: NSManagedObjectContext) throws -> [T] {
    return try fetchAll(withPredicate: nil, in: context)
  }
  
  static func fetchAll<T: NSManagedObject>(withPredicate predicate: NSPredicate?, in context: NSManagedObjectContext) throws -> [T] {
    let entityName = String(describing: self)
    let request = NSFetchRequest<T>(entityName: entityName)
    request.predicate = predicate
    return try context.fetch(request)
  }
  
  static func fetchFirst<T: NSManagedObject>(in context: NSManagedObjectContext) throws -> T? {
    return try fetchFirst(withPredicate: nil, in: context, sortedBy: nil)
  }
  
  static func fetchFirst<T: NSManagedObject>(in context: NSManagedObjectContext, sortedBy sort: [NSSortDescriptor]?) throws -> T? {
    return try fetchFirst(withPredicate: nil, in: context, sortedBy: sort)
  }
  
  static func fetchFirst<T: NSManagedObject>(withPredicate predicate: NSPredicate?, in context: NSManagedObjectContext) throws -> T? {
    return try fetchFirst(withPredicate: predicate, in: context, sortedBy: nil)
  }
  
  static func fetchFirst<T: NSManagedObject>(withPredicate predicate: NSPredicate?, in context: NSManagedObjectContext, sortedBy sort: [NSSortDescriptor]?) throws -> T? {
    let entityName = String(describing: self)
    let request = NSFetchRequest<T>(entityName: entityName)
    request.predicate = predicate
    request.fetchLimit = 1
    request.sortDescriptors = sort
    let fetch = try context.fetch(request)
    return fetch.first
  }
  
}

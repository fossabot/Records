//
//  Queryable.swift
//  Records
//
//  Created by Robert Nash on 20/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import Foundation
import CoreData

public protocol Queryable {
  associatedtype Entity: Fetchable
  func first(in context: NSManagedObjectContext) throws -> Entity?
  func first(in context: NSManagedObjectContext, sortedBy: [NSSortDescriptor]?) throws -> Entity?
  func all(in context: NSManagedObjectContext) throws -> [Entity]
  func predicateRepresentation() -> NSCompoundPredicate?
}

public extension Queryable {
  
  func first(in context: NSManagedObjectContext) throws -> Entity? {
    return try first(in: context, sortedBy: nil)
  }
  
  func first(in context: NSManagedObjectContext, sortedBy: [NSSortDescriptor]?) throws -> Entity? {
    return try Entity.fetchFirst(withPredicate: predicateRepresentation(), in: context, sortedBy: sortedBy) as? Entity
  }
  
  func all(in context: NSManagedObjectContext) throws -> [Entity] {
    return try Entity.fetchAll(withPredicate: predicateRepresentation(), in: context) as! [Entity]
  }

}

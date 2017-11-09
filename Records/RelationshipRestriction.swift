//
//  ManyRelationshipPredicate.swift
//  Records
//
//  Created by Robert Nash on 28/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import Foundation
import CoreData

public struct RelationshipRestriction {

  /**
   Inclusive operator. As per https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html
   
   - someMatching: Must include at least one.
   - allMatching: Must include all.
   - noneMatching: Must exclude all.
   */
  public enum Aggregate {
    case someMatching
    case allMatching
    case noneMatching
  }
  
  public let operation: Aggregate
  public let records: Set<NSManagedObject>
  
  public init(operation: Aggregate, records: Set<NSManagedObject>) {
    self.operation = operation
    self.records = records
  }
  
  public func predicate(_ name: String) -> NSPredicate {
    switch operation {
    case .allMatching:
      /// https://stackoverflow.com/a/47001325/1951992
      return NSPredicate(format: "SUBQUERY(\(name), $p, $p in %@).@count = %d", records, records.count)
    case .noneMatching:
      /// https://stackoverflow.com/a/19716571/1951992
      return NSPredicate(format: "SUBQUERY(\(name), $p, $p in %@).@count == 0", records)
    case .someMatching:
      return NSPredicate(format: "ANY " + name + " " + "IN" + " " + "%@", records)
    }
  }
  
}

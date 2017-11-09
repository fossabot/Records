//
//  Event.swift
//  Database
//
//  Created by Robert Nash on 21/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import Foundation
import CoreData
import Records

@objc(Event)
public class Event: NSManagedObject, Fetchable {
  
  @NSManaged public var startDate: Date
  
  @NSManaged public var performances: Set<Performance>?

}

// sourcery:inline:Event.ManagedObject.Query.stencil
public extension Event {
    struct Query {
        public var startDate: Date?
        public var performances: RelationshipRestriction?

        public init(startDate: Date?,performances: RelationshipRestriction?) {
          self.startDate = startDate 
          self.performances = performances 
        }
    }
}

extension Event.Query: Queryable {

    public typealias Entity = Event

    public func predicateRepresentation() -> NSCompoundPredicate? {
      var predicates = [NSPredicate]()
      if let predicate = startDatePredicate() {
        predicates.append(predicate)
      }
      if let predicate = performancesPredicate() {
        predicates.append(predicate)
      }
      if predicates.count == 0 {
        return nil
      }
      return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    private func startDatePredicate() -> NSPredicate? {
      guard let startDate = startDate else { return nil }
      return NSPredicate(format: "startDate == %@", startDate as CVarArg)
    }
    private func performancesPredicate() -> NSPredicate? {
      guard let performances = performances else { return nil }
      return performances.predicate("performances")
    }
}
// sourcery:end

public extension Event {
  
  /// sourcery:sourcerySkip
  var performerCount: Int {
    var uniquePerformers: Set<Performer> = []
    performances?.forEach({ (performance) in
      _ = performance.performers.filter({ (performer) -> Bool in
        if uniquePerformers.contains(performer) {
          return false
        } else {
          uniquePerformers.insert(performer)
          return true
        }
      })
    })
    return uniquePerformers.count
  }
  
}


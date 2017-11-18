//
//  Performer.swift
//  Database
//
//  Created by Robert Nash on 21/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import Foundation
import CoreData
import Records

@objc(Performer)
public class Performer: NSManagedObject, Fetchable {

  @NSManaged public var dob: Date
  
  @NSManaged public var firstName: String
  
  @NSManaged public var lastName: String
  
  @NSManaged public var party: Party
  
  @NSManaged public var performances: Set<Performance>?

}

// sourcery:inline:Performer.ManagedObject.Query.stencil
public extension Performer {
    struct Query {
        public var dob: Date?
        public var firstName: String?
        public var lastName: String?
        public var party: Party?
        public var performances: RelationshipRestriction?

        public init(dob: Date?,firstName: String?,lastName: String?,party: Party?,performances: RelationshipRestriction?) {
          self.dob = dob 
          self.firstName = firstName 
          self.lastName = lastName 
          self.party = party 
          self.performances = performances 
        }
    }
}

extension Performer.Query: Queryable {

    public typealias Entity = Performer

    public func predicateRepresentation() -> NSCompoundPredicate? {
      var predicates = [NSPredicate]()
      if let predicate = dobPredicate() {
        predicates.append(predicate)
      }
      if let predicate = firstNamePredicate() {
        predicates.append(predicate)
      }
      if let predicate = lastNamePredicate() {
        predicates.append(predicate)
      }
      if let predicate = partyPredicate() {
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

    private func dobPredicate() -> NSPredicate? {
      guard let dob = dob else { return nil }
      return NSPredicate(format: "dob == %@", dob as CVarArg)
    }
    private func firstNamePredicate() -> NSPredicate? {
      guard let firstName = firstName else { return nil }
      return NSPredicate(format: "firstName BEGINSWITH[cd] %@", firstName)
    }
    private func lastNamePredicate() -> NSPredicate? {
      guard let lastName = lastName else { return nil }
      return NSPredicate(format: "lastName BEGINSWITH[cd] %@", lastName)
    }
    private func partyPredicate() -> NSPredicate? {
      guard let party = party else { return nil }
      return NSPredicate(format: "party == %@", party as CVarArg)
    }
    private func performancesPredicate() -> NSPredicate? {
      guard let performances = performances else { return nil }
      return performances.predicate("performances")
    }
}
// sourcery:end

public extension Performer {
  
  //sourcery:sourcerySkip
  var fullName: String {
    return firstName + " " + lastName
  }
  
  func matches(fullName otherFullName: String) -> Bool {
    return fullName == otherFullName
  }

}

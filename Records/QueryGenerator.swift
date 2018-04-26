import CoreData

/// An interface for building predicates for CoreData fetch requests for records represented by `Entity`
public protocol QueryGenerator {
  associatedtype Entity: NSManagedObject
  /// A predicate for CoreData fetch requests
  var predicateRepresentation: NSCompoundPredicate? { get }
}

public extension QueryGenerator where Entity: Fetchable {
  
  func first(in context: NSManagedObjectContext) throws -> Entity? {
    return try first(in: context, sortedBy: nil)
  }
  
  func first(in context: NSManagedObjectContext, sortedBy: [NSSortDescriptor]?) throws -> Entity? {
    return try Entity.fetchFirst(withPredicate: predicateRepresentation, in: context, sortedBy: sortedBy) as? Entity
  }
  
  func all(in context: NSManagedObjectContext) throws -> [Entity] {
    return try Entity.fetchAll(withPredicate: predicateRepresentation, in: context) as! [Entity]
  }

}

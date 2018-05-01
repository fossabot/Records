import CoreData

public struct Aggregate<T: NSManagedObject> {
  /// Inclusive operators. As per https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html
  ///
  /// - someMatching: Must include at least one.
  /// - allMatching: Must include all.
  /// - noneMatching: Must exclude all.
  public enum Operator {
    case someMatching
    case allMatching
    case noneMatching
  }
  
  let operation: Operator
  let records: Set<T>
  
  public init(_ operation: Operator, records: Set<T>) {
    self.operation = operation
    self.records = records
  }
  
  /// Generates a predicate that restricts the query with an inclusive operator.
  ///
  /// - Parameter name: The name of the relationship
  /// - Returns: The predicate for restricting the query.
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

@available(*, deprecated: 3.1.0, message: "Please use Aggregate<T: NSManagedObject>")
public struct RelationshipRestriction {
  /// Inclusive operators. As per https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html
  ///
  /// - someMatching: Must include at least one.
  /// - allMatching: Must include all.
  /// - noneMatching: Must exclude all.
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

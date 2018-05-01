import CoreData

/// An interface for extracting records from CoreData
public protocol Fetchable where Self: NSManagedObject {
  associatedtype T: NSFetchRequestResult = Self
}

public extension Fetchable {
  /// This function counts the total records saved for the CoreData Model Entity represented by the invocant of this function.
  ///
  /// - Parameter context: The object associated with the relevant persistent store co-ordinator you would like to query.
  /// - Returns: The total count of records.
  /// - Throws: Errors from the CoreData layer.
  static func count(in context: NSManagedObjectContext) throws -> Int {
    let entityName = typeName(self)
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
    return try context.count(for: request)
  }
  /// This function retrieves all saved records for the CoreData Model Entity represented by the invocant of this function.
  ///
  /// - Parameters:
  ///   - predicate: A custom predicate to restrict the query.
  ///   - context: The object associated with the relevant persistent store co-ordinator you would like to query.
  /// - Returns: Every available record that matches the predicate.
  /// - Throws: Errors from the CoreData layer.
  static func fetchAll(withPredicate predicate: NSPredicate? = nil, in context: NSManagedObjectContext) throws -> [T] {
    let entityName = typeName(self)
    let request = NSFetchRequest<T>(entityName: entityName)
    request.predicate = predicate
    return try context.fetch(request)
  }
  /// This function retrieves the first saved record found, for the CoreData Model Entity represented by the invocant of this function.
  ///
  /// - Parameters:
  ///   - predicate: A custom predicate to restrict the query.
  ///   - context: The object associated with the relevant persistent store co-ordinator you would like to query.
  ///   - sort: The sorting that should take place, before the first record is selected.
  /// - Returns: The first saved record found. Any other records are ignored.
  /// - Throws: Errors from the CoreData layer.
  static func fetchFirst(withPredicate predicate: NSPredicate? = nil, in context: NSManagedObjectContext, sortedBy sort: [NSSortDescriptor]? = nil) throws -> T? {
    let entityName = typeName(self)
    let request = NSFetchRequest<T>(entityName: entityName)
    request.predicate = predicate
    request.fetchLimit = 1
    request.sortDescriptors = sort
    let fetch = try context.fetch(request)
    return fetch.first
  }
}

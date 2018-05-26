import CoreData

/// Can be stored as a CoreData record.
public protocol Recordable {
  associatedtype RecordQuery: QueryGenerator where RecordQuery.Entity.T == RecordQuery.Entity
  /// This must be a query for a unique record. If this value is nil, the first record discovered will be overwritten.
  var primaryKey: RecordQuery? { get }
  /// Called when a record is to be updated with fresh data
  ///
  /// - Parameter record: The record to be updated.
  func update(record: RecordQuery.Entity)
}

extension Recordable {
  /// The target record that best represents the reciever. If one does not exist, it will be created.
  /// If no primary key is provided, the first record found in the database will be overwritten.
  /// If one does not exist, it will be created.
  ///
  /// - Parameters:
  ///   - context: The context to use for performing this task
  /// - Returns: The record mapped with all matching data.
  /// - Throws: CoreData layer errors
  @discardableResult public func record(in context: NSManagedObjectContext) throws -> RecordQuery.Entity {
    if let query = primaryKey {
      return try fetchOrCreate(in: context) { try query.first(in: context) }
    }
    return try fetchOrCreate(in: context) { try RecordQuery.Entity.fetchFirst(in: context) }
  }
    
  private func fetchOrCreate(in context: NSManagedObjectContext, block: @escaping () throws -> RecordQuery.Entity?) throws -> RecordQuery.Entity {
    if let record = try block() {
      update(record: record)
      return record
    } else {
      let record = RecordQuery.Entity(context: context)
      update(record: record)
      return record
    }
  }
}

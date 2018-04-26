import UIKit
import CoreData

open class FetchedResultsController<Entity: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
  
  public typealias ContentChanged = (Int) -> Void
  
  public var contentChanged: ContentChanged?
  
  public weak var delegate: FetchedResultsControllerDelegate?
  
  public weak var dataSource: FetchedResultsControllerDatasource?
  
  public let context: NSManagedObjectContext
  
  public private(set) lazy var fetchedResultsController: NSFetchedResultsController<Entity> = {
    return build()
  }()
  
  public required init(context: NSManagedObjectContext) throws {
    self.context = context
    super.init()
  }
  
  private func load() throws {
    fetchedResultsController = build()
    try fetchedResultsController.performFetch()
  }
  
  public func reload() throws {
    try load()
    delegate?.didReload()
  }
  
  private func build() -> NSFetchedResultsController<Entity> {
    let name = typeName(Entity.self)
    let fetchRequest: NSFetchRequest<Entity> = NSFetchRequest<Entity>(entityName: name)
    fetchRequest.fetchBatchSize = 100
    fetchRequest.predicate = self.predicate()
    fetchRequest.sortDescriptors = self.sortDescriptors()
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: sectionNameKeyPath(), cacheName: nil)
    controller.delegate = self
    return controller
  }
  
  open func predicate() -> NSCompoundPredicate { return NSCompoundPredicate(andPredicateWithSubpredicates: []) }
  
  open func sortDescriptors() -> [NSSortDescriptor] { return [] }
  
  open func sectionNameKeyPath() -> String? { return nil }
  
  open func configure(cell: UITableViewCell, withEntity entity: Entity) {
  }
  
  //MARK: NSFetchedResultsControllerDelegate
  
  open func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    delegate?.willChangeContent()
  }
  
  open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
    case .insert:
      if newIndexPath != nil {
        delegate?.insertRowsAt(indexPaths: [newIndexPath!])
      }
    case .delete:
      if indexPath != nil {
        delegate?.deleteRowsAt(indexPaths: [indexPath!])
      }
    case .update:
      if indexPath != nil {
        if let cell = dataSource?.tableViewCell(at: indexPath!) {
          configure(cell: cell, withEntity: anObject as! Entity)
        }
      }
    case .move:
      if indexPath != nil {
        delegate?.deleteRowsAt(indexPaths: [indexPath!])
      }
      if newIndexPath != nil {
        delegate?.insertRowsAt(indexPaths: [newIndexPath!])
      }
    }
  }
  
  open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    if case .delete = type {
      delegate?.deleteSectionAt(section: sectionIndex)
    }
    if case .insert = type {
      delegate?.insertSectionAt(section: sectionIndex)
    }
  }
  
  open func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    delegate?.didChangeContent()
    contentChanged?(controller.fetchedObjects?.count ?? 0)
  }
  
}

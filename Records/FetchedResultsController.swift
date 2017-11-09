//
//  FetchedResultsController.swift
//  Records
//
//  Created by Robert Nash on 20/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import CoreData

open class FetchedResultsController<Entity: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
  
  public typealias ContentChanged = () -> Void
  
  public var contentChanged: ContentChanged?
  
  public weak var delegate: FetchedResultsControllerDelegate?
  
  public weak var dataSource: FetchedResultsControllerDatasource?
  
  public let context: NSManagedObjectContext
  
  public private(set)var fetchedResultsController: NSFetchedResultsController<Entity>!
  
  public required init(context: NSManagedObjectContext) throws {
    self.context = context
    super.init()
    try load()
  }
  
  private func load() throws {
    let name = String(describing: Entity.self)
    let fetchRequest: NSFetchRequest<Entity> = NSFetchRequest<Entity>(entityName: name)
    fetchRequest.fetchBatchSize = 100
    fetchRequest.predicate = self.predicate()
    fetchRequest.sortDescriptors = self.sortDescriptors()
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: sectionNameKeyPath(), cacheName: nil)
    controller.delegate = self
    try controller.performFetch()
    fetchedResultsController = controller
  }
  
  public func reload() throws {
    try load()
    delegate?.didReload()
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
    contentChanged?()
  }
  
}

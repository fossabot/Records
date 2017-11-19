//
//  PerformersFetchedResultsController.swift
//  RecordsDemo
//
//  Created by Robert Nash on 01/11/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Database
import CoreData

final class PerformersFetchedResultsController: TableViewCoreDataBinding<Performer> {
  
  var event: Event? {
    didSet {
      try? reload()
    }
  }
  
  var performerFirstName: String? {
    didSet {
      try? reload()
    }
  }
  
  func indexPath(for performer: Performer) -> IndexPath? {
    return fetchedResultsController.indexPath(forObject: performer)
  }
    
  //MARK: FetchedResultsController Overrides
  
  override func predicate() -> NSCompoundPredicate {
    var predicates = [NSPredicate]()
    if event != nil {
      predicates.append(NSPredicate(format: "ANY performances.event == %@", event!))
    }
    if performerFirstName != nil && performerFirstName!.isEmpty == false {
      predicates.append(NSPredicate(format: "firstName BEGINSWITH[cd] %@", performerFirstName!))
    }
    return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
  }
  
  override func sortDescriptors() -> [NSSortDescriptor] {
    return [NSSortDescriptor(key: "firstName", ascending: true)]
  }
  
  //MARK: UITableViewDataSource Overrides
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequableTableView: DequeableTableView = (tableView as? DequeableTableView).require(hint: "Must conform to DequableTableView")
    let cell: PerformerTableViewCell = dequableTableView.dequeue(indexPath)
    configure(cell: cell, atIndexPath: indexPath)
    return cell
  }
  
  override func configure(cell: UITableViewCell, withEntity entity: Performer) {
    let cell: PerformerTableViewCell = (cell as? PerformerTableViewCell).require(hint: "Was expecting PerformerTableViewCell")
    cell.update(withPerformer: entity)
  }
  
  var selectPerformer: PerformerConsumer?
  
  //MARK: UITableViewDelegate Overrides
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let entity = fetchedResultsController.object(at: indexPath)
    selectPerformer?(entity)
  }
  
}

//
//  PerformancesFetchedResultsController.swift
//  RecordsDemo
//
//  Created by Robert Nash on 30/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Database
import CoreData
import Dequable

class PerformancesFetchedResultsController: TableViewCoreDataBinding<Performance> {
  
  var event: Event? {
    didSet {
      try? reload()
    }
  }
  
  //MARK: FetchedResultsController Overrides
  
  override func predicate() -> NSCompoundPredicate {
    if event != nil {
      return NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "event == %@", event!)])
    }
    return super.predicate()
  }
  
  private let sectionName = "group"
  
  override func sortDescriptors() -> [NSSortDescriptor] {
    return [NSSortDescriptor(key: sectionName, ascending: true)]
  }
  
  override func sectionNameKeyPath() -> String? {
    return sectionName
  }
  
  //MARK: UITableViewDataSource Overrides
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequableTableView: DequeableTableView = (tableView as? DequeableTableView).require(hint: "Must conform to DequableTableView")
    let cell: PerformanceTableViewCell = dequableTableView.dequeue(indexPath)
    configure(cell: cell, atIndexPath: indexPath)
    return cell
  }
  
  override func configure(cell: UITableViewCell, withEntity entity: Performance) {
    let cell: PerformanceTableViewCell = (cell as? PerformanceTableViewCell).require(hint: "Was expecting PerformanceTableViewCell")
    cell.update(withPerformance: entity)
  }
  
  var selectPerformance: PerformanceConsumer?
  
  //MARK: UITableViewDelegate Overrides
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let entity = fetchedResultsController.object(at: indexPath)
    selectPerformance?(entity)
  }
  
}

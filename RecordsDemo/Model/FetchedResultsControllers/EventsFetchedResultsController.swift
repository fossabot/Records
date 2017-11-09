//
//  EventsController.swift
//  RecordsDemo
//
//  Created by Robert Nash on 21/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Database

final class EventsFetchedResultsController: TableViewCoreDataBinding<Event> {
  
  convenience init() {
    try! self.init(context: Storage.sharedInstance.persistentContainer.viewContext)
  }
  
  //MARK: FetchedResultsController Overrides
  
  override func sortDescriptors() -> [NSSortDescriptor] {
    return [NSSortDescriptor(key: "startDate", ascending: true)]
  }
  
  //MARK: UITableViewDataSource Overrides
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequableTableView: DequeableTableView = (tableView as? DequeableTableView).require(hint: "Must conform to DequableTableView")
    let cell: EventTableViewCell = dequableTableView.dequeue(indexPath)
    configure(cell: cell, atIndexPath: indexPath)
    return cell
  }
  
  override func configure(cell: UITableViewCell, withEntity entity: Event) {
    let cell: EventTableViewCell = (cell as? EventTableViewCell).require(hint: "Was expecting EventTableViewCell")
    cell.update(withDate: entity.startDate, withCount: entity.performances?.count ?? 0)
  }
  
  var selectEvent: EventConsumer?
  
  //MARK: UITableViewDelegate Overrides
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let entity = fetchedResultsController.object(at: indexPath)
    if entity.performances?.count == 0 {
      tableView.deselectRow(at: indexPath, animated: true)
    } else {
      selectEvent?(entity)
    }
  }

}

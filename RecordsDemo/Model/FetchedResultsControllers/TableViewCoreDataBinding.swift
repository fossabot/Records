//
//  TableViewCoreDataBinding.swift
//  RecordsDemo
//
//  Created by Robert Nash on 03/11/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Records
import CoreData

class TableViewCoreDataBinding<Entity: NSManagedObject>: FetchedResultsController<Entity>, UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.sections?[section].numberOfObjects ?? 0
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return fetchedResultsController.sections?[section].name
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    fatalError("Must override.")
  }
  
  func configure(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
    let entity = fetchedResultsController.object(at: indexPath)
    configure(cell: cell, withEntity: entity)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    let entity = fetchedResultsController.object(at: indexPath)
    context.delete(entity)
    try? context.save()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? { return nil }
  
}

//
//  EventsFetchedResultsControllerDatasource.swift
//  Records
//
//  Created by Robert Nash on 20/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit

public protocol FetchedResultsControllerDatasource: class {
  func tableViewCell(at indexPath: IndexPath) -> UITableViewCell?
}

public extension FetchedResultsControllerDatasource where Self: UITableView {
  
  func tableViewCell(at indexPath: IndexPath) -> UITableViewCell? {
    return cellForRow(at: indexPath)
  }
  
}

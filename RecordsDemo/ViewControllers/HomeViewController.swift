//
//  HomeViewController.swift
//  RecordsDemo
//
//  Created by Robert Nash on 07/11/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

  private let context = Storage.sharedInstance.persistentContainer.viewContext
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let performersViewController = (segue.destination as? FilterPerformersViewController) {
      performersViewController.fetchedResultsController = try! PerformersFetchedResultsController(context: context)
    }
    if let performancesViewController = (segue.destination as? PerformancesViewController) {
      performancesViewController.fetchedResultsController = try! PerformancesFetchedResultsController(context: context)
    }
  }
  
}

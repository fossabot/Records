//
//  PerformancesViewController.swift
//  RecordsDemo
//
//  Created by Robert Nash on 30/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit

class PerformancesViewController: UIViewController {
  
  var fetchedResultsController: PerformancesFetchedResultsController!
  
  @IBOutlet private weak var tableView: PerformancesTableView! {
    didSet {
      fetchedResultsController?.delegate = tableView
      fetchedResultsController?.dataSource = tableView
      tableView.dataSource = fetchedResultsController
      tableView.delegate = fetchedResultsController
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Performances"
  }
  
}

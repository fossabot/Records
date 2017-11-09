//
//  PerformersViewController.swift
//  RecordsDemo
//
//  Created by Robert Nash on 01/11/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Database

class PerformersViewController: UIViewController {
  
  var fetchedResultsController: PerformersFetchedResultsController!
  
  var selectPerformer: PerformerConsumer!
  
  @IBOutlet weak var tableView: PerformersTableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = fetchedResultsController
    tableView.delegate = fetchedResultsController
    fetchedResultsController.delegate = tableView
    fetchedResultsController.dataSource = tableView
    fetchedResultsController.selectPerformer = selectPerformer
    title = "Performers"
  }
  
}

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
  
  var selectPerformer: PerformerConsumer?
  
  @IBOutlet weak var tableView: PerformersTableView! {
    didSet {
      fetchedResultsController.delegate = tableView
      fetchedResultsController.dataSource = tableView
      tableView.dataSource = fetchedResultsController
      tableView.delegate = fetchedResultsController
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchedResultsController.selectPerformer = selectPerformer
    title = "Performers"
  }
  
}

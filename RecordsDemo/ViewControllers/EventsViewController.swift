//
//  EventsViewController.swift
//  RecordsDemo
//
//  Created by Robert Nash on 21/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Database

final class EventsViewController: UIViewController {
  
  private let fetchedResultsController = EventsFetchedResultsController()
  
  @IBOutlet private weak var tableView: EventsTableView! {
    didSet {
      fetchedResultsController.delegate = tableView
      fetchedResultsController.dataSource = tableView
      tableView.dataSource = fetchedResultsController
      tableView.delegate = fetchedResultsController
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Events"
    fetchedResultsController.selectEvent = { [unowned self] event in
      self.performSegue(withIdentifier: "summary", sender: event)
    }
    fetchedResultsController.contentChanged = { print("Something changed") }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    (segue.destination as? EventViewController)?.event = sender as? Event
  }
  
}

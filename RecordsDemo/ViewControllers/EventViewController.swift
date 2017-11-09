//
//  RootViewController.swift
//  RecordsDemo
//
//  Created by Robert Nash on 01/11/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Database

class EventViewController: UIViewController {
  
  var event: Event!
  
  private let context = Storage.sharedInstance.persistentContainer.viewContext
  
  @IBOutlet private weak var eventLabel: EventTitleLabel! {
    didSet {
      eventLabel.update(withStartDate: event.startDate)
    }
  }
  
  @IBOutlet private weak var performersButton: PerformersMenuButton! {
    didSet {
      performersButton.update(withPerformerCount: event.performerCount)
    }
  }
  
  @IBOutlet private weak var performancesButton: PerformancesMenuButton! {
    didSet {
      performancesButton.update(withPerformancesCount: event.performances?.count ?? 0)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let performancesViewController = segue.destination as? PerformancesViewController {
      performancesViewController.fetchedResultsController = buildPerformancesFetchedResultsController()
    }
    if let performersViewController = segue.destination as? PerformersViewController {
      performersViewController.fetchedResultsController = buildPerformersFetchedResultsController()
    }
  }
  
  private func buildPerformancesFetchedResultsController() -> PerformancesFetchedResultsController {
    let fetchedResultsController = try! PerformancesFetchedResultsController(context: context)
    fetchedResultsController.event = event
    return fetchedResultsController
  }
  
  private func buildPerformersFetchedResultsController() -> PerformersFetchedResultsController {
    let fetchedResultsController = try! PerformersFetchedResultsController(context: context)
    fetchedResultsController.event = event
    return fetchedResultsController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Summary"
  }
  
}

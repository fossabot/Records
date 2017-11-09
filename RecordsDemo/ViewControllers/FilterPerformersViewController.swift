//
//  SearchPerformancesViewController.swift
//  RecordsDemo
//
//  Created by Robert Nash on 03/11/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Database

final class FilterPerformersViewController: PerformersViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Filter"
  }
  
  @IBAction func textFieldEditingChanged(_ sender: UITextField) {
    fetchedResultsController.performerFirstName = sender.text
  }

}

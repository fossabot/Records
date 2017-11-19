//
//  SearchPerformersViewController.swift
//  RecordsDemo
//
//  Created by Robert Nash on 07/11/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Database

class SearchPerformersViewController: UIViewController, UITableViewDataSource {
  
  private let context = Storage.sharedInstance.persistentContainer.viewContext
  
  @IBOutlet private weak var tableView: PerformersTableView! {
    didSet {
      tableView.dataSource = self
    }
  }
  
  @IBOutlet private weak var footerLabel: UILabel! {
    didSet {
      
      
      let performer: Performer? = try! Performer.fetchFirst(in: context)
      footerLabel.text = "Example: \"\(performer!.firstName)\""
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Performers"
  }
  
  private var performers: [Performer] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  @IBOutlet private weak var textField: UITextField!
  
  @IBAction func searchButtonPressed(_ sender: UIButton) {
    let query = Performer.Query(dob: nil, firstName: textField.text, lastName: nil, party: nil, performances: nil)
    performers = try! query.all(in: context)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return performers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequableTableView: DequeableTableView = (tableView as? DequeableTableView).require(hint: "Must conform to DequableTableView")
    let cell: PerformerTableViewCell = dequableTableView.dequeue(indexPath)
    cell.update(withPerformer: performers[indexPath.row])
    return cell
  }
  
}

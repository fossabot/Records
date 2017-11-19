//
//  RelationshipRestrictionViewController.swift
//  RecordsDemo
//
//  Created by Robert Nash on 07/11/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Records
import Database

class RelationshipRestrictionViewController: UIViewController {
  
  private enum PickerView: Int {
    case first
    case second
    case third
  }
  
  @IBOutlet private weak var firstTextField: UITextField! {
    didSet {
      let pickerView = UIPickerView()
      pickerView.tag = PickerView.first.rawValue
      pickerView.dataSource = self
      pickerView.delegate = self
      firstTextField.inputView = pickerView
      firstTextField.delegate = self
      firstTextField.text = performerA.fullName
    }
  }
  
  @IBOutlet private weak var secondTextField: UITextField! {
    didSet {
      let pickerView = UIPickerView()
      pickerView.tag = PickerView.second.rawValue
      pickerView.dataSource = self
      pickerView.delegate = self
      pickerView.selectRow(1, inComponent: 0, animated: false) // initial performerB position
      secondTextField.inputView = pickerView
      secondTextField.delegate = self
      secondTextField.text = performerB.fullName
    }
  }
  
  @IBOutlet weak var thirdTextField: UITextField! {
    didSet {
      let pickerView = UIPickerView()
      pickerView.tag = PickerView.third.rawValue
      pickerView.dataSource = self
      pickerView.delegate = self
      thirdTextField.inputView = pickerView
      thirdTextField.delegate = self
      thirdTextField.text = String(describing: aggregateOperator)
    }
  }
  
  @IBOutlet private weak var tableView: PerformancesTableView! {
    didSet {
      tableView.dataSource = self
    }
  }
  
  private let context = Storage.sharedInstance.persistentContainer.viewContext
  
  private lazy var performers: [Performer] = { [unowned self] in
    return try! Performer.fetchAll(in: self.context)
    }()
  
  private lazy var performerA: Performer = { [unowned self] in
    return self.performers[0]
  }()
  
  private lazy var performerB: Performer = { [unowned self] in
    return self.performers[1]
  }()
  
  private var selections: Set<Performer> {
    return Set(arrayLiteral: performerA, performerB)
  }
  
  private lazy var operators: [RelationshipRestriction.Aggregate] = {
    return [.noneMatching, .someMatching, .allMatching]
  }()
  
  private lazy var aggregateOperator: RelationshipRestriction.Aggregate = {
    return self.operators[0]
  }()
  
  private var performances: [Performance] {
    let restriction = RelationshipRestriction(operation: aggregateOperator, records: selections)
    let query = Performance.Query(performers: restriction, event: nil, ability: nil, group: nil)
    return try! query.all(in: context)
  }
  
}

extension RelationshipRestrictionViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return performances.count == 0 ? 0 : 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return performances.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dequableTableView: DequeableTableView = (tableView as? DequeableTableView).require(hint: "Must conform to DequableTableView")
    let cell: PerformanceTableViewCell = dequableTableView.dequeue(indexPath)
    cell.update(withPerformance: performances[indexPath.row], highlightingPerformers: selections)
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Performances"
  }
  
}

extension RelationshipRestrictionViewController: UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if case .third = PickerView(rawValue: pickerView.tag).require() {
      return operators.count
    }
    return performers.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if case .third = PickerView(rawValue: pickerView.tag).require() {
      let o = operators[row]
      return String(describing: o)
    }
    let p = performers[row]
    return p.fullName
  }
  
}

extension RelationshipRestrictionViewController: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch PickerView(rawValue: pickerView.tag).require() {
    case .first:
      let p = performers[row]
      performerA = p
      firstTextField.text = p.fullName
    case .second:
      let p = performers[row]
      performerB = p
      secondTextField.text = p.fullName
    case .third:
      let o = operators[row]
      aggregateOperator = o
      thirdTextField.text = String(describing: o)
    }
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
      self.tableView.reloadData()
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
      }
    }
  }
  
}

extension RelationshipRestrictionViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(_:)))
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    navigationItem.rightBarButtonItem = nil
  }
  
  @objc private func doneButtonPressed(_ sender: UIBarButtonItem) {
    view.endEditing(true)
  }
  
}

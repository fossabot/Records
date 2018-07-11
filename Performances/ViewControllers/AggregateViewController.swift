import UIKit
import Dequable
import Require

class AggregateViewController: UIViewController {
    private enum PickerView: Int {
        case first
        case second
        case third
    }
    @IBOutlet private weak var firstTextField: UITextField! {
        didSet {
            let index = self.performers.index(of: self.performerA).require(hint: message3("PerformerA"))
            let pickerView = UIPickerView()
            pickerView.tag = PickerView.first.rawValue
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.selectRow(index, inComponent: 0, animated: false)
            firstTextField.inputView = pickerView
            firstTextField.delegate = self
            firstTextField.text = performerA.fullName
        }
    }
    @IBOutlet private weak var secondTextField: UITextField! {
        didSet {
            let index = self.performers.index(of: self.performerB).require(hint: message3("PerformerB"))
            let pickerView = UIPickerView()
            pickerView.tag = PickerView.second.rawValue
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.selectRow(index, inComponent: 0, animated: false)
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
            tableView.delegate = self
        }
    }
    private let context = Storage.sharedInstance.persistentContainer.viewContext
    private lazy var performers: [Performer] = { [unowned self] in
        do {
            return try Performer.fetchAll(in: self.context)
        } catch {
            fatalError(message1)
        }
        }()
    private lazy var performerA: Performer = { [unowned self] in
        do {
            let query = Performer.Query(firstName: "Angel")
            let performer: Performer? = try query.first(in: self.context)
            return performer.require(hint: message3("Angel"))
        } catch {
            fatalError(message1)
        }
        }()
    private lazy var performerB: Performer = { [unowned self] in
        do {
            let query = Performer.Query(firstName: "Maggie", lastName: "Phillips")
            let performer: Performer? = try query.first(in: self.context)
            return performer.require(hint: message3("Maggie"))
        } catch {
            fatalError(message1)
        }
        }()
    private var selections: Set<Performer> {
        return [performerA, performerB]
    }
    private lazy var operators: [Aggregate<Performer>.Operator] = {
        return [.someMatching, .noneMatching, .allMatching]
    }()
    private lazy var aggregateOperator: Aggregate<Performer>.Operator = { [unowned self] in
        return self.operators[0]
        }()
    private var performances: [Performance] {
        let aggregate = Aggregate<Performer>(aggregateOperator, records: selections)
        let query = Performance.Query(performers: aggregate)
        do {
            return try query.all(in: context)
        } catch {
            fatalError(message1)
        }
    }
}

extension AggregateViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return performances.count == 0 ? 0 : 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performances.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequableTableView: DequeableTableView = (tableView as? DequeableTableView).require(hint: message2(DequeableTableView.self))
        let cell: PerformanceTableViewCell = dequableTableView.dequeue(indexPath)
        cell.update(withPerformance: performances[indexPath.row], highlightingPerformers: selections)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Performances"
    }
}

extension AggregateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let performance = performances[indexPath.row]
        let group = performance.group_.rawValue
        let name = performance.performers.first.require(hint: message4).firstName
        print("Selected " + group.lowercased() + " containing: " + name)
    }
}

extension AggregateViewController: UIPickerViewDataSource {
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
            return String(describing: operators[row])
        }
        return performers[row].fullName
    }
}

extension AggregateViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch PickerView(rawValue: pickerView.tag).require() {
        case .first:
            let performer = performers[row]
            performerA = performer
            firstTextField.text = performer.fullName
        case .second:
            let performer = performers[row]
            performerB = performer
            secondTextField.text = performer.fullName
        case .third:
            let ops = operators[row]
            aggregateOperator = ops
            thirdTextField.text = String(describing: ops)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.tableView.reloadData()
            if self.performances.count > 0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
        }
    }
}

extension AggregateViewController: UITextFieldDelegate {
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

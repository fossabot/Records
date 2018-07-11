import UIKit
import Dequable
import Require

class SearchPerformersViewController: UIViewController, UITableViewDataSource {
    private let context = Storage.sharedInstance.persistentContainer.viewContext
    @IBOutlet private weak var tableView: PerformersTableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    @IBOutlet private weak var footerLabel: UILabel! {
        didSet {
            do {
                let storedRecord: Performer? = try Performer.fetchFirst(in: context)
                let performer: Performer = storedRecord.require(hint: message4)
                footerLabel.text = "Example: \"\(performer.firstName)\""
            } catch {
                fatalError(message1)
            }
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
        let query = Performer.Query(firstName: textField.text)
        do {
            performers = try query.all(in: context)
        } catch {
            fatalError(message1)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return performers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequableTableView: DequeableTableView = (tableView as? DequeableTableView).require(hint: message2(DequeableTableView.self))
        let cell: PerformerTableViewCell = dequableTableView.dequeue(indexPath)
        cell.update(withPerformer: performers[indexPath.row])
        return cell
    }
}

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
        fetchedResultsController.selectPerformance = { performance in
            let group = performance.group_.rawValue
            let name = performance.performers.first.require(hint: message4).firstName
            print("Selected " + group.lowercased() + " containing: " + name)
        }
    }
}

import UIKit

class PerformersViewController: UIViewController {
    var fetchedResultsController: PerformersFetchedResultsController!
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
        fetchedResultsController.selectPerformer = { performer in
            print("Selected " + performer.firstName)
        }
        title = "Performers"
        do {
          try fetchedResultsController.reload()
        } catch {
          fatalError(message1)
        }
    }
}

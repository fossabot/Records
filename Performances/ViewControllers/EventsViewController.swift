import UIKit

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
        fetchedResultsController.contentChanged = { count in
            print("Something changed. Record count: \(count)")
        }
        do {
            try fetchedResultsController.reload()
        } catch {
            fatalError(message1)
        }
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

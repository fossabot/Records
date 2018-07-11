import UIKit

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
        do {
            let fetchedResultsController = try PerformancesFetchedResultsController(context: context)
            fetchedResultsController.event = event
            return fetchedResultsController
        } catch {
            fatalError(message1)
        }
    }
    private func buildPerformersFetchedResultsController() -> PerformersFetchedResultsController {
        do {
            let fetchedResultsController = try PerformersFetchedResultsController(context: context)
            fetchedResultsController.event = event
            return fetchedResultsController
        } catch {
            fatalError(message1)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Summary"
    }
}

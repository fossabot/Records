import UIKit

class HomeViewController: UITableViewController {
    private let context = Storage.sharedInstance.persistentContainer.viewContext
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        do {
            if let performersViewController = (segue.destination as? FilterPerformersViewController) {
                performersViewController.fetchedResultsController = try PerformersFetchedResultsController(context: context)
            }
            if let performancesViewController = (segue.destination as? PerformancesViewController) {
                performancesViewController.fetchedResultsController = try PerformancesFetchedResultsController(context: context)
            }
        } catch {
            fatalError(message1)
        }
    }
}

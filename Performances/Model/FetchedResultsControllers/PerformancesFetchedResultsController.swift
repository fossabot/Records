import UIKit
import Dequable
import Require

final class PerformancesFetchedResultsController: FetchedResultsController<Performance>, UITableViewDataSource, UITableViewDelegate {
    var event: Event? {
        didSet {
            do {
                try reload()
            } catch {
                fatalError(message1)
            }
        }
    }
    override func predicate() -> NSCompoundPredicate {
        guard let event = event else {
            return super.predicate()
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "event == %@", event)])
    }
    private let sectionName = "group"
    override func sortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: sectionName, ascending: true)]
    }
    override func sectionNameKeyPath() -> String? {
        return sectionName
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequableTableView: DequeableTableView = (tableView as? DequeableTableView).require(hint: message2(DequeableTableView.self))
        let cell: PerformanceTableViewCell = dequableTableView.dequeue(indexPath)
        configure(cell: cell, atIndexPath: indexPath)
        return cell
    }
    func configure(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        let entity = fetchedResultsController.object(at: indexPath)
        configure(cell: cell, withEntity: entity)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let entity = fetchedResultsController.object(at: indexPath)
        context.delete(entity)
        do {
            try context.save()
        } catch {
            fatalError(message1)
        }
    }
    var selectPerformance: PerformanceConsumer?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = fetchedResultsController.object(at: indexPath)
        selectPerformance?(entity)
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return nil
    }
    override func configure(cell: UITableViewCell, withEntity entity: Performance) {
        let cell: PerformanceTableViewCell = (cell as? PerformanceTableViewCell).require(hint: message2(PerformanceTableViewCell.self))
        cell.update(withPerformance: entity)
    }
}

import UIKit
import Dequable
import Require

final class PerformersFetchedResultsController: FetchedResultsController<Performer>, UITableViewDataSource, UITableViewDelegate {
    var event: Event? {
        didSet {
            do {
                try reload()
            } catch {
                fatalError(message1)
            }
        }
    }
    var performerFirstName: String? {
        didSet {
            do {
                try reload()
            } catch {
                fatalError(message1)
            }
        }
    }
    func indexPath(for performer: Performer) -> IndexPath? {
        return fetchedResultsController.indexPath(forObject: performer)
    }
    /// event and/or performerFirstName or none
    override func predicate() -> NSCompoundPredicate {
        var predicates = [NSPredicate]()
        if let event = event {
            predicates.append(NSPredicate(format: "ANY performances.event == %@", event))
        }
        if let performerFirstName = performerFirstName, performerFirstName.isEmpty == false {
            predicates.append(NSPredicate(format: "firstName BEGINSWITH[cd] %@", performerFirstName))
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    override func sortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "firstName", ascending: true)]
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
        let cell: PerformerTableViewCell = dequableTableView.dequeue(indexPath)
        configure(cell: cell, atIndexPath: indexPath)
        return cell
    }
    func configure(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        let entity = fetchedResultsController.object(at: indexPath)
        configure(cell: cell, withEntity: entity)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let entity = fetchedResultsController.object(at: indexPath)
        context.delete(entity)
        try? context.save()
    }
    var selectPerformer: PerformerConsumer?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = fetchedResultsController.object(at: indexPath)
        selectPerformer?(entity)
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return nil
    }
    override func configure(cell: UITableViewCell, withEntity entity: Performer) {
        let cell: PerformerTableViewCell = (cell as? PerformerTableViewCell).require(hint: message2(PerformerTableViewCell.self))
        cell.update(withPerformer: entity)
    }
}

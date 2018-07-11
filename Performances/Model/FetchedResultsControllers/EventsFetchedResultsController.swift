import UIKit
import Dequable
import Require

final class EventsFetchedResultsController: FetchedResultsController<Event>, UITableViewDataSource, UITableViewDelegate {
    convenience init() {
        do {
            try self.init(context: Storage.sharedInstance.persistentContainer.viewContext)
        } catch {
            fatalError(message1)
        }
    }
    override func sortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "startDate", ascending: true)]
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
        let cell: EventTableViewCell = dequableTableView.dequeue(indexPath)
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
        do {
            try context.save()
        } catch {
            fatalError(message1)
        }
    }
    var selectEvent: EventConsumer?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = fetchedResultsController.object(at: indexPath)
        if entity.performances?.count == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            selectEvent?(entity)
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return nil
    }
    override func configure(cell: UITableViewCell, withEntity entity: Event) {
        let cell: EventTableViewCell = (cell as? EventTableViewCell).require(hint: message2(EventTableViewCell.self))
        cell.update(withDate: entity.startDate, withCount: entity.performances?.count ?? 0)
    }
}

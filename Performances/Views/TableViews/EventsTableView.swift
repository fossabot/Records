import UIKit
import Dequable
import Records

final class EventsTableView: UITableView, FetchedResultsControllerDelegate, FetchedResultsControllerDatasource, DequeableTableView {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    register(cellType: EventTableViewCell.self)
  }
}

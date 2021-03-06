import UIKit
import Dequable
import Records

class PerformancesTableView: UITableView, FetchedResultsControllerDelegate, FetchedResultsControllerDatasource, DequeableTableView {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    register(cellType: PerformanceTableViewCell.self)
  }
}

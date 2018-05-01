import UIKit

public protocol FetchedResultsControllerDatasource: class {
  func tableViewCell(at indexPath: IndexPath) -> UITableViewCell?
}

public extension FetchedResultsControllerDatasource where Self: UITableView {
  func tableViewCell(at indexPath: IndexPath) -> UITableViewCell? {
    return cellForRow(at: indexPath)
  }
}

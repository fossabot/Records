import UIKit

public protocol FetchedResultsControllerDelegate: class {
  func insertRowsAt(indexPaths: [IndexPath])
  func insertSectionAt(section: Int)
  func deleteRowsAt(indexPaths: [IndexPath])
  func deleteSectionAt(section: Int)
  func willChangeContent()
  func didChangeContent()
  func didReload()
}

public extension FetchedResultsControllerDelegate where Self: UITableView {
  
  func insertRowsAt(indexPaths: [IndexPath]) {
    insertRows(at: indexPaths, with: .fade)
  }
  
  func insertSectionAt(section: Int) {
    insertSections(IndexSet(integer: section), with: .automatic)
  }
  
  func deleteRowsAt(indexPaths: [IndexPath]) {
    deleteRows(at: indexPaths, with: .fade)
  }
  
  func deleteSectionAt(section: Int) {
    deleteSections(IndexSet(integer: section), with: .automatic)
  }
  
  func willChangeContent() {
    beginUpdates()
  }
  
  func didChangeContent() {
    endUpdates()
  }
  
  func didReload() {
    reloadData()
  }
  
}

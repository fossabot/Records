import UIKit
import Dequable

class PerformerTableViewCell: UITableViewCell, DequeableComponentIdentifiable {
  private struct ViewModel {
    static func title(forPerformer performer: Performer) -> String {
      return performer.fullName
    }
    static func subtitle(forPerformer performer: Performer) -> String {
      return performer.party.name
    }
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func update(withPerformer performer: Performer) {
    textLabel?.text = ViewModel.title(forPerformer: performer)
    detailTextLabel?.text = ViewModel.subtitle(forPerformer: performer)
  }
}

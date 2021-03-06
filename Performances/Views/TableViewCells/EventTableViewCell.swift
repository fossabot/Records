import UIKit
import Dequable

class EventTableViewCell: UITableViewCell, DequeableComponentIdentifiable {
  private struct ViewModel {
    static func title(forStartDate startDate: Date) -> String {
      return "Start Date: " + eventDateFormatter.string(from: startDate)
    }
    static func subtitle(forCount count: Int) -> String {
      let value = (count == 1) ? "performance" : "performances"
      return "\(count) " + value + " registered"
    }
    static func accessoryType(forCount count: Int) -> UITableViewCellAccessoryType {
      return (count == 0) ? .none : .disclosureIndicator
    }
  }
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func update(withDate date: Date, withCount count: Int) {
    textLabel?.text = ViewModel.title(forStartDate: date)
    detailTextLabel?.text = ViewModel.subtitle(forCount: count)
    accessoryType = ViewModel.accessoryType(forCount: count)
  }
}

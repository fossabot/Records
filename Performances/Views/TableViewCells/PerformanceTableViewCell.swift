import UIKit
import Dequable

class PerformanceTableViewCell: UITableViewCell, DequeableComponentIdentifiable {
  private struct ViewModel {
    static func title(forPerformance performance: Performance) -> NSAttributedString {
      let value = performance.group_.rawValue + " " + performance.ability_.rawValue
      return NSAttributedString(string: value, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    static func subtitle(forPerformance performance: Performance, withPerformers performers: Set<Performer>? = nil) -> NSAttributedString {
      return performance.performers.reduce(NSMutableAttributedString()) { (accumulation, performer) -> NSMutableAttributedString in
        let value: String
        if accumulation.length == 0 {
          value = performer.fullName
        } else {
          value = ", " + performer.fullName
        }
        if let performers = performers, performers.contains(where: { $0.matches(fullName: performer.fullName) }) {
          return accumulation.bold(value)
        }
        return accumulation.normal(value)
      }
    }
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    detailTextLabel?.numberOfLines = 0
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func update(withPerformance performance: Performance, highlightingPerformers performers: Set<Performer>? = nil) {
    textLabel?.attributedText = ViewModel.title(forPerformance: performance)
    detailTextLabel?.attributedText = ViewModel.subtitle(forPerformance: performance, withPerformers: performers)
  }
}

import UIKit

class PerformancesMenuButton: UIButton {
  private struct ViewModel {
    static func buttonTitle(forCount count: Int) -> String {
      let value = (count == 1) ? "performance" : "performances"
      return "\(count) " + value + " registered"
    }
  }
  func update(withPerformancesCount count: Int) {
    setTitle(ViewModel.buttonTitle(forCount: count), for: .normal)
  }
}

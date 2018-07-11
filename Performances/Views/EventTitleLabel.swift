import UIKit

class EventTitleLabel: UILabel {
    private struct ViewModel {
        static func title(forStartDate startDate: Date) -> String {
            return "Start Date: " + eventDateFormatter.string(from: startDate)
        }
    }
    func update(withStartDate date: Date) {
        text = ViewModel.title(forStartDate: date)
    }
}

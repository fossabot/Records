import UIKit

final class FilterPerformersViewController: PerformersViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter"
    }
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        fetchedResultsController.performerFirstName = sender.text
    }
}

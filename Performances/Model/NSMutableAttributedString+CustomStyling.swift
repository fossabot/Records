import UIKit
import Require

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-DemiBold", size: 14).require(hint: "The fonts have been ripped out of the project. Hmm...")]
        append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-Regular", size: 14).require(hint: "The fonts have been ripped out of the project. Hmm...")]
        append(NSAttributedString(string: text, attributes: attrs))
        return self
    }
}

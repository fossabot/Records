//
//  DequeableTableView.swift
//  Dequable
//
//  Created by Robert Nash on 19/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit

public protocol DequeableTableView: Dequeable {
    func register(headerFooterViewType: DequeableComponentIdentifiable.Type, hasNib: Bool)
    func dequeue<T>(_ indexPath: IndexPath) -> T where T : UITableViewCell & DequeableComponentIdentifiable
}

extension DequeableTableView where Self: UITableView {
    
    public func register(headerFooterViewType: DequeableComponentIdentifiable.Type, hasNib: Bool) {
        let name = String(describing: headerFooterViewType)
        let identifier = headerFooterViewType.dequableComponentIdentifier
        if hasNib == true {
            let nib = UINib(nibName: name, bundle: Bundle(for: headerFooterViewType))
            register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        } else {
            register(headerFooterViewType, forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
    
    public func dequeue<T>(_ indexPath: IndexPath) -> T where T : UITableViewCell & DequeableComponentIdentifiable {
        return dequeueReusableCell(withIdentifier: T.dequableComponentIdentifier, for: indexPath) as! T
    }
    
}

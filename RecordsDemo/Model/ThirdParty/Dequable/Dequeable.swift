//
//  DequeueMechanismIdentifiable.swift
//  Dequable
//
//  Created by Robert Nash on 19/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit

public protocol Dequeable {
    func register(cellType: DequeableComponentIdentifiable.Type, hasNib: Bool)
}

extension Dequeable where Self: UITableView {
    
    public func register(cellType: DequeableComponentIdentifiable.Type, hasNib: Bool) {
        let name = String(describing: cellType)
        let identifier = cellType.dequableComponentIdentifier
        if hasNib == true {
            let nib = UINib(nibName: name, bundle: Bundle(for: cellType))
            register(nib, forCellReuseIdentifier: identifier)
        } else {
            register(cellType, forCellReuseIdentifier: identifier)
        }
    }
    
}

extension Dequeable where Self: UICollectionView {
    
    public func register(cellType: DequeableComponentIdentifiable.Type, hasNib: Bool) {
        let name = String(describing: cellType)
        let identifier = cellType.dequableComponentIdentifier
        if hasNib == true {
            let nib = UINib(nibName: name, bundle: Bundle(for: cellType))
            register(nib, forCellWithReuseIdentifier: identifier)
        } else {
            register(cellType, forCellWithReuseIdentifier: identifier)
        }
    }
    
}

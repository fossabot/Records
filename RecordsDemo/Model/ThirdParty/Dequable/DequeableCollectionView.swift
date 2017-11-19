//
//  DequeableCollectionView.swift
//  Dequable
//
//  Created by Robert Nash on 19/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit

public protocol DequeableCollectionView: Dequeable {
    func dequeue(cellType: DequeableComponentIdentifiable.Type, atIndexPath indexPath: IndexPath) -> UICollectionViewCell
}

extension DequeableCollectionView where Self: UICollectionView {
    
    public func dequeue(cellType: DequeableComponentIdentifiable.Type, atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = cellType.dequableComponentIdentifier
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
}

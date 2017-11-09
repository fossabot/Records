//
//  DequeableComponentIdentifiable.swift
//  Dequable
//
//  Created by Robert Nash on 19/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

/// https://github.com/rob-nash/Dequable == 1.0.0

import Foundation

public protocol DequeableComponentIdentifiable: class {
    static var dequableComponentIdentifier: String { get }
}

extension DequeableComponentIdentifiable {
    
    public static var dequableComponentIdentifier: String {
        return String(describing: self) + "ID"
    }
    
}

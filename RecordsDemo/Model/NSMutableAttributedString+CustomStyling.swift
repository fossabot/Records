//
//  NSMutableAttributedString+CustomStyling.swift
//  RecordsDemo
//
//  Created by Robert Nash on 09/11/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
  @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
    let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-DemiBold", size: 14).require()]
    append(NSMutableAttributedString(string:text, attributes: attrs))
    return self
  }
  
  @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
    let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-Regular", size: 14).require()]
    append(NSAttributedString(string: text, attributes: attrs))
    return self
  }
  
}

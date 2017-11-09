//
//  PerformersMenuButton.swift
//  RecordsDemo
//
//  Created by Robert Nash on 01/11/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit

class PerformersMenuButton: UIButton {
  
  private struct ViewModel {
    
    static func buttonTitle(forCount count: Int) -> String {
      let value = (count == 1) ? "performer" : "performers"
      return "\(count) " + value + " registered"
    }
    
  }
  
  func update(withPerformerCount count: Int) {
    setTitle(ViewModel.buttonTitle(forCount: count), for: .normal)
  }
  
}

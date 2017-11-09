//
//  PerformerTableViewCell.swift
//  RecordsDemo
//
//  Created by Robert Nash on 01/11/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Database

class PerformerTableViewCell: UITableViewCell, DequeableComponentIdentifiable {
  
  private struct ViewModel {
    
    static func title(forPerformer performer: Performer) -> String {
      return performer.fullName
    }
    
    static func subtitle(forPerformer performer: Performer) -> String {
      return performer.party.name
    }
    
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(withPerformer performer: Performer) {
    textLabel?.text = ViewModel.title(forPerformer: performer)
    detailTextLabel?.text = ViewModel.subtitle(forPerformer: performer)
  }
  
}

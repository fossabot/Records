//
//  PerformersTableView.swift
//  RecordsDemo
//
//  Created by Robert Nash on 01/11/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Records

class PerformersTableView: UITableView, FetchedResultsControllerDelegate, FetchedResultsControllerDatasource, DequeableTableView {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    register(cellType: PerformerTableViewCell.self, hasNib: false)
  }
  
}

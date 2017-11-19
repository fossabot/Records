//
//  PerformancesTableView.swift
//  RecordsDemo
//
//  Created by Robert Nash on 30/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Records

class PerformancesTableView: UITableView, FetchedResultsControllerDelegate, FetchedResultsControllerDatasource, DequeableTableView {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    register(cellType: PerformanceTableViewCell.self, hasNib: false)
  }
  
}

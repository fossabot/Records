//
//  EventsTableView.swift
//  RecordsDemo
//
//  Created by Robert Nash on 21/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Records

final class EventsTableView: UITableView, FetchedResultsControllerDelegate, FetchedResultsControllerDatasource, DequeableTableView {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    register(cellType: EventTableViewCell.self, hasNib: false)
  }

}

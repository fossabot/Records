//
//  Consumers.swift
//  RecordsDemo
//
//  Created by Robert Nash on 03/11/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import Database

typealias PerformerConsumer = (Performer) -> Void
typealias EventConsumer = (Event) -> Void
typealias PerformanceConsumer = (Performance) -> Void
typealias FirstNameConsumer = (String?) -> Void

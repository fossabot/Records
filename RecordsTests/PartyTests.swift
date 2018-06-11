//
//  PartyTests.swift
//  RecordsTests
//
//  Created by Robert Nash on 30/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import Foundation
import Database
import CoreData
import XCTest

final class PartyTests: XCTestCase {
  
  private var context: NSManagedObjectContext!
  
  override func setUp() {
    super.setUp()
    /// The persistent store must be re-created for each test. The persistent store is 'InMemoryOnly' so once it is destroyed, the records are also destroyed; allowing each test to be run with an empty database.
    context = Storage.load().viewContext
  }
  
  func testDefaultValues() {
    let party = Party(context: context)
    let message = "Default value missing"
    XCTAssert(party.type_ == .school, message)
  }
  
}

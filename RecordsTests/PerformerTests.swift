//
//  PerformerTests.swift
//  RecordsTests
//
//  Created by Robert Nash on 21/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import Foundation
import Database
import CoreData
import XCTest

class PerformerTests: XCTestCase {
  
  private var context: NSManagedObjectContext!
  
  override func setUp() {
    super.setUp()
    /// The persistent store must be re-created for each test. The persistent store is 'InMemoryOnly' so once it is destroyed, the records are also destroyed; allowing each test to be run with an empty database.
    context = Storage.load().viewContext
  }
  
  func testFetchFirst() {
    let date = Date()
    var performer: Performer!
    performer = Performer(context: context)
    performer.firstName = "Bob"
    performer.lastName = "Nash"
    performer.dob = Calendar.current.date(byAdding: .year, value: -1, to: date)!
    let name = "Stacey"
    performer = Performer(context: context)
    performer.firstName = name
    performer.lastName = "Nash"
    performer.dob = Calendar.current.date(byAdding: .year, value: -2, to: date)!
    let dob = Calendar.current.date(byAdding: .year, value: -3, to: date)!
    performer = Performer(context: context)
    performer.firstName = "Carl"
    performer.lastName = "Nash"
    performer.dob = dob
    let predicate = NSPredicate(format: "dob > %@", dob as CVarArg)
    let sortDescriptor = NSSortDescriptor(key: "dob", ascending: true)
    let a: Performer? = try! Performer.fetchFirst(withPredicate: predicate, in: context, sortedBy: [sortDescriptor])
    XCTAssert(a?.firstName == name)
  }
  
  private func createPerfomers(count: Int, inContext context: NSManagedObjectContext) {
    let date = Date()
    for _ in 0..<count {
      let performer = Performer(context: context)
      performer.firstName = "Bob"
      performer.lastName = "Nash"
      performer.dob = date
    }
  }
  
  func testFetchAll1() {
    let count: Int = 3
    createPerfomers(count: count, inContext: context)
    let all: [Performer]? = try! Performer.fetchAll(in: context)
    let total = all?.count ?? 0
    XCTAssert(total == count, String(format: "Total is %i not: %i", total, count))
  }
  
  func testFetchAll2() {
    let count: Int = 3
    createPerfomers(count: count, inContext: context)
    let query = Performer.Query(firstName: "Bob", lastName: "Nash")
    let all: [Performer]? = try! query.all(in: context)
    let total = all?.count ?? 0
    XCTAssert(total == count, String(format: "Total is %i not: %i", total, count))
  }
  
  func testFetchAll3() {
    let count: Int = 3
    createPerfomers(count: count, inContext: context)
    let date = Date()
    let name = "David"
      var performer: Performer!
    performer = Performer(context: context)
    performer.firstName = name
    performer.lastName = "Nash"
    performer.dob = date
    let predicate = NSPredicate(format: "firstName == %@", name)
    let all: [Performer]? = try! Performer.fetchAll(withPredicate: predicate, in: context)
    let total = all?.count ?? 0
    XCTAssert(total == 1, String(format: "Total is %i not: %i", total, count))
    performer = all?.first
    XCTAssert(performer.firstName == name)
  }
  
}

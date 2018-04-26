//
//  QueryTests.swift
//  RecordsTests
//
//  Created by Robert Nash on 30/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import Foundation
import Database
import Records
import CoreData
import XCTest

class QueryTests: XCTestCase {
  
  private var context: NSManagedObjectContext!
  
  override func setUp() {
    super.setUp()
    /// The persistent store must be re-created for each test. The persistent store is 'InMemoryOnly' so once it is destroyed, the records are also destroyed; allowing each test to be run with an empty database.
    context = Storage.load().viewContext
    DataBuilder(context: context).populateDatabase()
  }
  
  func testSomeMatching() {
    guard let p1 = try! Performer.Query(firstName: "Angel", lastName: "Jones").first(in: context) else {
      XCTFail("Performer not found")
      return
    }
    guard let p2 = try! Performer.Query(firstName: "Ashton", lastName: "Longworth").first(in: context)  else {
      XCTFail("Performer not found")
      return
    }
    let pred = Aggregate<Performer>(.someMatching, records: Set([p1,p2]))
    let query = Performance.Query(performers: pred)
    let performances: [Performance] = try! query.all(in: context)
    XCTAssert(performances.count == 4)
    performances.forEach { (performance) in
      XCTAssert(performance.performers.contains(p1) || performance.performers.contains(p2))
    }
  }
  
  func testAllMatching() {
    guard let p1 = try! Performer.Query(firstName: "Angel", lastName: "Jones").first(in: context) else {
      XCTFail("Performer not found")
      return
    }
    guard let p2 = try! Performer.Query(firstName: "Ashton", lastName: "Longworth").first(in: context)  else {
      XCTFail("Performer not found")
      return
    }
    let pred = Aggregate<Performer>(.allMatching, records: Set([p1,p2]))
    let query = Performance.Query(performers: pred)
    let performances: [Performance] = try! query.all(in: context)
    XCTAssert(performances.count == 2)
    performances.forEach { (performance) in
      XCTAssert(performance.performers.contains(p1) && performance.performers.contains(p2))
    }
  }
  
  func testNoneMatching() {
    guard let p1 = try! Performer.Query(firstName: "Angel", lastName: "Jones").first(in: context) else {
      XCTFail("Performer not found")
      return
    }
    guard let p2 = try! Performer.Query(firstName: "Ashton", lastName: "Longworth").first(in: context)  else {
      XCTFail("Performer not found")
      return
    }
    let pred = Aggregate<Performer>(.noneMatching, records: Set([p1,p2]))
    let query = Performance.Query(performers: pred)
    let performances: [Performance] = try! query.all(in: context)
    XCTAssert(performances.count == 19)
    performances.forEach { (performance) in
      XCTAssert(!performance.performers.contains(p1) || !performance.performers.contains(p2))
    }
  }
  
}

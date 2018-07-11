//
//  PredicateTests.swift
//  RecordsTests
//
//  Created by Robert Nash on 09/06/2018.
//  Copyright © 2018 Robert Nash. All rights reserved.
//

import UIKit
@testable import Records
import CoreData
import XCTest

final class FetchedResultsControllerTests: XCTestCase {
  
  private var context: NSManagedObjectContext!
  
  override func setUp() {
    super.setUp()
    /// The persistent store must be re-created for each test. The persistent store is 'InMemoryOnly' so once it is destroyed, the records are also destroyed; allowing each test to be run with an empty database.
    context = Storage.load().viewContext
    try! DataBuilder(context: context).populateDatabase()
    try! context.save()
  }
  
  // Test initialiser
  func testFetchedResultsControllerTests0() throws {
    let controller = try FetchedResultsController<Event>(context: context)
    XCTAssert(controller.context == context)
  }
  
  // Test delegate 1 - didReload()
  func testFetchedResultsControllerTests1() throws {
    final class Delegate: FetchedResultsControllerDelegate {
      var did = false
      func insertRowsAt(indexPaths: [IndexPath]) {}
      func insertSectionAt(section: Int) {}
      func deleteRowsAt(indexPaths: [IndexPath]) {}
      func deleteSectionAt(section: Int) {}
      func willChangeContent() {}
      func didChangeContent() {}
      func didReload() {
        did = true
      }
    }
    let delegate = Delegate()
    let controller = try FetchedResultsController<Event>(context: context)
    controller.delegate = delegate
    try controller.reload()
    XCTAssert(delegate.did == true, "Delegate didReload() did not fire.")
  }
  
  // Test delegate 2 - insertRowsAt(indexPaths:)
  func testFetchedResultsControllerTests2() throws {
    final class Delegate: FetchedResultsControllerDelegate {
      var didInsert = false
      func insertRowsAt(indexPaths: [IndexPath]) {
        guard let indexPath = indexPaths.first else {
          XCTFail()
          return
        }
        XCTAssert(indexPath.section == 0)
        XCTAssert(indexPath.row == 2)
        didInsert = true
      }
      func insertSectionAt(section: Int) {}
      func deleteRowsAt(indexPaths: [IndexPath]) {}
      func deleteSectionAt(section: Int) {}
      func willChangeContent() {}
      func didChangeContent() {}
      func didReload() {}
    }
    let delegate = Delegate()
    let controller = try FetchedResultsController<Event>(context: context)
    controller.delegate = delegate
    try controller.reload()
    let event = Event(context: context)
    var components = DateComponents()
    components.year = 2018
    components.month = 2
    components.day = 4
    let date = Calendar.current.date(from: components)!
    event.startDate = date
    try context.save()
    XCTAssert(delegate.didInsert == true)
  }
  
  // Test delegate 3 - insertSectionAt(section:)
  func testFetchedResultsControllerTests3() throws {
    final class PerformancesFetchedResultsController: FetchedResultsController<Performance> {
      private let sectionName = "group"
      override func sectionNameKeyPath() -> String? {
        return sectionName
      }
      override func sortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: sectionName, ascending: true)]
      }
    }
    final class Delegate: FetchedResultsControllerDelegate {
      var didInsert = false
      func insertRowsAt(indexPaths: [IndexPath]) {}
      func insertSectionAt(section: Int) {
        didInsert = true
      }
      func deleteRowsAt(indexPaths: [IndexPath]) {}
      func deleteSectionAt(section: Int) {}
      func willChangeContent() {}
      func didChangeContent() {}
      func didReload() {}
    }
    let delegate = Delegate()
    let controller = try PerformancesFetchedResultsController(context: context)
    controller.delegate = delegate
    try controller.reload()
    let event = try Event.fetchFirst(in: context)!
    let performance = Performance(context: context)
    performance.event = event
    performance.ability_ = .advanced
    performance.group_ = .quad
    let party = try Party.fetchFirst(in: context)!
    for i in 0..<4 {
      let performer = Performer(context: context)
      performer.firstName = "firstName\(i)"
      performer.lastName = "lastName\(i)"
      performer.dob = Date()
      performer.party = party
      performance.performers.insert(performer)
    }
    try context.save()
    XCTAssert(delegate.didInsert == true)
  }
  
  // Test delegate 4 - deleteRowsAt(indexPaths: )
  func testFetchedResultsControllerTests4() throws {
    final class Delegate: FetchedResultsControllerDelegate {
      var didDelete = false
      func insertRowsAt(indexPaths: [IndexPath]) {}
      func insertSectionAt(section: Int) {}
      func deleteRowsAt(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
          XCTAssert(indexPath.section == 0)
          XCTAssert(indexPath.row == 0)
        }
        didDelete = true
      }
      func deleteSectionAt(section: Int) {}
      func willChangeContent() {}
      func didChangeContent() {}
      func didReload() {}
    }
    let delegate = Delegate()
    let controller = try FetchedResultsController<Event>(context: context)
    controller.delegate = delegate
    try controller.reload()
    let event = try Event.fetchFirst(in: context)!
    context.delete(event)
    try context.save()
    XCTAssert(delegate.didDelete == true)
  }
  
  // Test delegate 5 - deleteSectionAt(section:)
  func testFetchedResultsControllerTests5() throws {
    final class PerformancesFetchedResultsController: FetchedResultsController<Performance> {
      private let sectionName = "group"
      override func sectionNameKeyPath() -> String? {
        return sectionName
      }
      override func sortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: sectionName, ascending: true)]
      }
    }
    final class Delegate: FetchedResultsControllerDelegate {
      var didDelete = false
      func insertRowsAt(indexPaths: [IndexPath]) {}
      func insertSectionAt(section: Int) {}
      func deleteRowsAt(indexPaths: [IndexPath]) {}
      func deleteSectionAt(section: Int) {
        XCTAssert(section == 1)
        didDelete = true
      }
      func willChangeContent() {}
      func didChangeContent() {}
      func didReload() {}
    }
    let delegate = Delegate()
    let controller = try PerformancesFetchedResultsController(context: context)
    controller.delegate = delegate
    try controller.reload()
    let performances = try Performance.Query(group: .solo).all(in: context)
    performances.forEach { (performance) in
      context.delete(performance)
    }
    try context.save()
    XCTAssert(delegate.didDelete == true)
  }
  
  // Test delegate 6 - willChangeContent() / didChangeContent()
  func testFetchedResultsControllerTests6() throws {
    final class Delegate: FetchedResultsControllerDelegate {
      var willChange = false
      var didChange = false
      func insertRowsAt(indexPaths: [IndexPath]) {}
      func insertSectionAt(section: Int) {}
      func deleteRowsAt(indexPaths: [IndexPath]) {}
      func deleteSectionAt(section: Int) {}
      func willChangeContent() {
        willChange = true
      }
      func didChangeContent() {
        didChange = true
      }
      func didReload() {}
    }
    let delegate = Delegate()
    let controller = try FetchedResultsController<Event>(context: context)
    controller.delegate = delegate
    try controller.reload()
    let event = try Event.fetchFirst(in: context)!
    event.startDate = Date()
    try context.save()
    XCTAssert(delegate.willChange == true)
    XCTAssert(delegate.didChange == true)
  }
  
  // Test contentChanged
  func testFetchedResultsControllerTests7() throws {
    let controller = try FetchedResultsController<Event>(context: context)
    try controller.reload()
    var event = Event(context: context)
    event.startDate = Date()
    controller.contentChanged = { count in
      XCTAssert(count == 7, "Invalid count. Expected: 7, Actual: \(count)")
    }
    try context.save()
    event = Event(context: context)
    event.startDate = Date()
    controller.contentChanged = { count in
      XCTAssert(count == 8, "Invalid count. Expected: 8, Actual: \(count)")
    }
    try context.save()
  }
  
  // Test datasource
  func testFetchedResultsControllerTests8() throws {
    final class Datasource: FetchedResultsControllerDatasource {
      var didFire = false
      func tableViewCell(at indexPath: IndexPath) -> UITableViewCell? {
        XCTAssert(indexPath.section == 0)
        XCTAssert(indexPath.row == 0)
        didFire = true
        return nil
      }
    }
    let dataSource = Datasource()
    let controller = try FetchedResultsController<Event>(context: context)
    controller.dataSource = dataSource
    try controller.reload()
    let event = try Event.fetchFirst(in: context)!
    event.startDate = Date()
    try context.save()
    XCTAssert(dataSource.didFire == true)
  }
  
  // Test predicate 1
  func testFetchedResultsControllerTests9() throws {
    final class PerformancesFetchedResultsController: FetchedResultsController<Performance> {
      override func predicate() -> NSCompoundPredicate {
        let predicate1 = NSPredicate(format: "group == %@", "Solo")
        let predicate2 = NSPredicate(format: "ability == %@", "Newcomer")
        return NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
      }
    }
    let controller = try PerformancesFetchedResultsController(context: context)
    try controller.reload()
    let count = controller.fetchedResultsController.fetchedObjects!.count
    let expected: Int = 11
    XCTAssert(count == expected, "Unexpected data. Expected: \(expected). Actual: \(count)")
    let performance = controller.fetchedResultsController.fetchedObjects?.first
    let expectedGroup = Performance.Group.solo
    let actualGroup = String(describing: performance?.group_)
    let message1 = "Unexpected data. Expected: \(expectedGroup). Actual: \(actualGroup)"
    XCTAssert(performance?.group_ == expectedGroup, message1)
    let expectedability = Performance.Ability.newcomer
    let actualAbility = String(describing: performance?.ability_)
    let message2 = "Unexpected data. Expected: \(expectedability). Actual: \(actualAbility)."
    XCTAssert(performance?.ability_ == expectedability, message2)
    var components = DateComponents()
    components.year = 2018
    components.month = 2
    components.day = 4
    let date = Calendar.current.date(from: components)!
    let actualEvent = Event.Query(startDate: date)
    let expectedEvent = performance!.event
    let message3 = "Unexpected data. Expected event with startDate: \(String(describing: expectedEvent.startDate)). Actual: \(String(describing: actualEvent.startDate))"
    XCTAssert(performance?.event == expectedEvent, message3)
  }
  
  // Test predicate 2
  func testFetchedResultsControllerTests10() throws {
    final class PerformancesFetchedResultsController: FetchedResultsController<Performance> {
      override func predicate() -> NSCompoundPredicate {
        let predicate1 = NSPredicate(format: "group == %@", "Duo")
        let predicate2 = NSPredicate(format: "ability == %@", "Newcomer")
        return NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
      }
    }
    let controller = try PerformancesFetchedResultsController(context: context)
    try controller.reload()
    let count = controller.fetchedResultsController.fetchedObjects!.count
    let expected: Int = 7
    XCTAssert(count == expected, "Unexpected data. Expected: \(expected). Actual: \(count)")
    let performance = controller.fetchedResultsController.fetchedObjects?.first
    let expectedGroup = Performance.Group.duo
    let actualGroup = String(describing: performance?.group_)
    let message1 = "Unexpected data. Expected: \(expectedGroup). Actual: \(actualGroup)"
    XCTAssert(performance?.group_ == expectedGroup, message1)
    let expectedability = Performance.Ability.newcomer
    let actualAbility = String(describing: performance?.ability_)
    let message2 = "Unexpected data. Expected: \(expectedability). Actual: \(actualAbility)."
    XCTAssert(performance?.ability_ == expectedability, message2)
    var components = DateComponents()
    components.year = 2018
    components.month = 2
    components.day = 4
    let date = Calendar.current.date(from: components)!
    let actualEvent = Event.Query(startDate: date)
    let expectedEvent = performance!.event
    let message3 = "Unexpected data. Expected event with startDate: \(String(describing: expectedEvent.startDate)). Actual: \(String(describing: actualEvent.startDate))"
    XCTAssert(performance?.event == expectedEvent, message3)
  }
  
  // Test configure(cell:, withEntity entity:)
  func testFetchedResultsControllerTests11() throws {
    final class EventsFetchedResultsController: FetchedResultsController<Event> {
      override func configure(cell: UITableViewCell, withEntity entity: Event) {
        var components = DateComponents()
        components.year = 2018
        components.month = 5
        components.day = 6
        let date = Calendar.current.date(from: components)!
        XCTAssert(entity.startDate == date)
      }
    }
    final class Datasource: FetchedResultsControllerDatasource {
      func tableViewCell(at indexPath: IndexPath) -> UITableViewCell? {
        return UITableViewCell()
      }
    }
    let dataSource = Datasource()
    let controller = try EventsFetchedResultsController(context: context)
    controller.dataSource = dataSource
    try controller.reload()
    var components = DateComponents()
    components.year = 2018
    components.month = 5
    components.day = 6
    let date = Calendar.current.date(from: components)!
    let event = try Event.fetchFirst(in: context)!
    event.startDate = date
    try context.save()
  }
}

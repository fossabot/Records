//
//  QueryTests.swift
//  RecordsTests
//
//  Created by Robert Nash on 30/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import Foundation
@testable import Database
import Records
import CoreData
import XCTest

class QueryTests: XCTestCase {
    private var context: NSManagedObjectContext!
    override func setUp() {
        super.setUp()
        /// The persistent store must be re-created for each test. The persistent store is 'InMemoryOnly' so once it is destroyed, the records are also destroyed; allowing each test to be run with an empty database.
        context = Storage.load().viewContext
        try! DataBuilder(context: context).populateDatabase()
    }
    func testEventCount() throws {
        let count = try Event.count(in: context)
        let records = try Event.fetchAll(in: context)
        XCTAssertTrue(records.count == 6, "Expecting 6. Actual \(records.count).")
        XCTAssertTrue(records.count == count)
    }
    func testPerformerCount() throws {
        let count = try Performer.count(in: context)
        let records = try Performer.fetchAll(in: context)
        XCTAssertTrue(records.count == 29, "Expecting 29. Actual \(records.count).")
        XCTAssertTrue(records.count == count)
    }
    func testPerformanceCount() throws {
        let count = try Performance.count(in: context)
        let records = try Performance.fetchAll(in: context)
        XCTAssertTrue(records.count == 23, "Expecting 23. Actual \(records.count).")
        XCTAssertTrue(records.count == count)
    }
    func testSomeMatching() throws {
        guard let p1 = try Performer.Query(firstName: "Angel", lastName: "Jones").first(in: context) else {
            XCTFail("Performer not found")
            return
        }
        guard let p2 = try Performer.Query(firstName: "Ashton", lastName: "Longworth").first(in: context)  else {
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
    func testCreateEventRecord() throws {
        let date = Date()
        let data = DataBuilder.Event(startDate: date)
        let record = try data.record(in: context)
        XCTAssertTrue(record.startDate == date)
    }
    func testCreatePerformerAndPartyRecords() throws {
        let firstName = "Rob"
        let lastName = "Nash"
        let dob = Date()
        let performerData = DataBuilder.Performer(firstName: firstName, lastName: lastName, dob: dob)
        let parent = "Rob Nash"
        let phone = "01928374892"
        let email = "bob@nash.com"
        let type = "Independent"
        let partyData = DataBuilder.Party(name: parent, phone: phone, email: email, type: type)
        let party = try partyData.record(in: context)
        let export = performerData.export(withParty: party)
        let performer = try export.record(in: context)
        XCTAssertTrue(performer.firstName == firstName)
        XCTAssertTrue(performer.lastName == lastName)
        XCTAssertTrue(performer.dob == dob)
        XCTAssertTrue(performer.party == party)
        XCTAssertTrue(party.name == parent)
        XCTAssertTrue(party.phone == phone)
        XCTAssertTrue(party.email == email)
        XCTAssertTrue(party.type_.rawValue == type)
    }
    func testCreatePerformanceRecord() throws {
        let parent = "Rob Nash"
        let phone = "01928374892"
        let email = "bob@nash.com"
        let type = "Independent"
        let partyData = DataBuilder.Party(name: parent, phone: phone, email: email, type: type)
        let party = try partyData.record(in: context)
        let date = Date()
        let eventData = DataBuilder.Event(startDate: date)
        let event = try eventData.record(in: context)
        let firstName = "Rob"
        let lastName = "Nash"
        let dob = Date()
        let performerData = DataBuilder.Performer(firstName: firstName, lastName: lastName, dob: dob)
        let performers = [performerData]
        let ability = "Newcomer"
        let group = "Solo"
        let performanceData = DataBuilder.Performance(ability: ability, group: group, performers: performers)
        let export = try performanceData.export(withEvent: event, withParty: party, withContext: context)
        let performance = try export.record(in: context)
        XCTAssertTrue(performance.ability_.rawValue == ability)
        XCTAssertTrue(performance.group_.rawValue == group)
        let performer = performance.performers.first
        XCTAssertNotNil(performer)
        XCTAssertTrue(performer!.firstName == firstName)
        XCTAssertTrue(performer!.lastName == lastName)
        XCTAssertTrue(performer!.dob == dob)
        XCTAssertTrue(performer!.party == party)
        XCTAssertTrue(performance.event == event)
        XCTAssertTrue(party.email == email)
        XCTAssertTrue(party.phone == phone)
        XCTAssertTrue(party.name == parent)
        XCTAssertTrue(party.type_.rawValue == type)
        XCTAssertTrue(event.startDate == date)
    }
}

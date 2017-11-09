//
//  DataBuilder.swift
//  RecordsDemo
//
//  Created by Robert Nash on 21/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import Foundation
import CoreData
import Records

public struct DataBuilder {
  
  private let context: NSManagedObjectContext
  
  public init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  public func populateDatabase() {
    let events: [Database.Event] = unpackEvents().map { event in
        /// The record is created if it does not already exist.
        let record = event.record(in: context)
        return record
    }
    let parties: [Database.Party] = unpackParties().map { party in
        /// The record is created if it does not already exist.
        let record = party.record(in: context)
        return record
    }
    let _: [Database.Performance] = unpackPerformances().map { performance in
        /// Let's assume all performances are for the party at position 'first' and the event at position 'first'.
        let event = events.first!
        let party = parties.first!
        /// The record is created if it does not already exist.
        let record = performance.record(forParty: party, forEvent: event, in: context)
        return record
    }
  }
  
  private func unpackEvents() -> [Event] {
    let data = contentsOf(resource: "Events", extension: "json")
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(eventDateFormatter)
    return try! decoder.decode([Event].self, from: data)
  }
  
  private let eventDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d/M/yyyy"
    return dateFormatter
  }()
  
  private func unpackParties() -> [Party] {
    let data = contentsOf(resource: "Parties", extension: "json")
    let decoder = JSONDecoder()
    return try! decoder.decode([Party].self, from: data)
  }
  
  private func unpackPerformances() -> [Performance] {
    let data = contentsOf(resource: "Performances", extension: "json")
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dobDateFormatter)
    return try! decoder.decode([Performance].self, from: data)
  }
    
  private let dobDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d/M/yyyy"
    return dateFormatter
  }()
  
  private func contentsOf(resource r: String, extension e: String) -> Data {
    let bundle = Bundle(for: Database.Event.self)
    let url = bundle.url(forResource: r, withExtension: e)!
    return try! String(contentsOf: url).data(using: .utf8)!
  }
  
  struct Event: Decodable {
    let startDate: Date
    
    enum CodingKeys: String, CodingKey {
      case startDate = "StartDate"
    }
    
    func record(in context: NSManagedObjectContext) -> Database.Event {
      /// Query = Are there any events with this start date already in existence?
      let query = Database.Event.Query(startDate: startDate, performances: nil)
      let records = try! query.all(in: context)
      if records.count == 0 {
        let record = Database.Event(context: context)
        record.startDate = startDate
        return record
      }
      /// This is the only place we create events. Therefore, there should be 1 or 0 events for this date.
      return records.first!
    }

  }
  
  struct Party: Decodable {
    let name: String
    let phone: String
    let email: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
      case name = "Name"
      case phone = "Phone"
      case email = "Email"
      case type = "Type"
    }
    
    private var partyType: Database.Party.PartyType {
      return Database.Party.PartyType(rawValue: type)!
    }
    
    func record(in context: NSManagedObjectContext) -> Database.Party {
      /// Query = Does this party already exist, with or without associated performers?
      let query = Database.Party.Query(email: email, name: name, phone: phone, performers: nil, type: partyType)
      let records = try! query.all(in: context)
      if records.count == 0 {
        let record = Database.Party(context: context)
        record.email = email
        record.name = name
        record.phone = phone
        record.type_ = partyType
        return record
      }
      /// This is the only place we create Parties. Therefore, there should be 1 or 0 parties matching this info.
      return records.first!
    }
  }
  
  struct Performer: Decodable {
    let firstName: String
    let lastName: String
    let dob: Date
    
    enum CodingKeys: String, CodingKey {
        case firstName = "First Name"
        case lastName = "Last Name"
        case dob = "D.O.B"
    }
    
    /// There may be performers with identical details between parties and they may be the same person. Performers may change parties over time and we wouldn't know. Or performers may have the same details by coinsidence. So have decided to create a single record per performer per party.
    func record(forParty party: Database.Party, in context: NSManagedObjectContext) -> Database.Performer {
      /// Query = Does this performer already exist for this party? I don't care if they have performances at this point.
      let query = Database.Performer.Query(dob: dob, firstName: firstName, lastName: lastName, party: party, performances: nil)
      let records = try! query.all(in: context)
      if records.count == 0 {
        let record = Database.Performer(context: context)
        record.dob = dob
        record.firstName = firstName
        record.lastName = lastName
        record.party = party
        return record
      }
      /// This is the only place we create Performers. Therefore, there should be 1 or 0 performers matching this info.
      return records.first!
    }

  }
  
  struct Performance: Decodable {
    let ability: String
    let group: String
    let performers: [Performer]

    enum CodingKeys: String, CodingKey {
        case ability = "Ability"
        case group = "Group"
        case performers = "Performers"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ability = try values.decode(String.self, forKey: .ability)
        group = try values.decode(String.self, forKey: .group)
        performers = try values.decode([DataBuilder.Performer].self, forKey: .performers)
    }
    
    func record(forParty party: Database.Party, forEvent event: Database.Event, in context: NSManagedObjectContext) -> Database.Performance {
      let ability_ = Database.Performance.Ability(rawValue: ability)!
      let group_ = Database.Performance.Group(rawValue: group)!
      let performersRecords: [Database.Performer] = performers.map {
        $0.record(forParty: party, in: context)
      }
      let restriction = RelationshipRestriction(operation: .allMatching, records: Set(performersRecords))
        /// Query = Is there a performance for this event, at this ability, with this group type and these exact performers?
      let query = Database.Performance.Query(performers: restriction, event: event, ability: ability_, group: group_)
      let records = try! query.all(in: context)
      if records.count == 0 {
        let record = Database.Performance(context: context)
        record.ability_ = ability_
        record.group_ = group_
        record.event = event
        record.performers = Set(performersRecords)
        return record
      }
      /// This is the only place we create Performances. Therefore, there should be 1 or 0 performances matching this info.
      return records.first!
    }

  }

}

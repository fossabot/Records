//
//  DataBuilder.swift
//  RecordsTests
//
//  Created by Robert Nash on 09/06/2018.
//  Copyright © 2018 Robert Nash. All rights reserved.
//

import Foundation
import Database
@testable import Records
import CoreData

struct DataBuilder {
  private let context: NSManagedObjectContext
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  func populateDatabase() throws {
    let events: [Database.Event] = try unpackEvents().map {
      return try $0.record(in: context)
    }
    let parties: [Database.Party] = try unpackParties().map {
      return try $0.record(in: context)
    }
    let _: [Database.Performance] = try unpackPerformances().map {
      let event = events.first!
      let party = parties.first!
      let export = try $0.export(withEvent: event, withParty: party, withContext: context)
      return try export.record(in: context)
    }
  }
  private func unpackEvents() throws -> [Event] {
    let data = try contentsOf(resource: "Events", extension: "json")
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(eventDateFormatter)
    return try decoder.decode([Event].self, from: data)
  }
  private let eventDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d/M/yyyy"
    return dateFormatter
  }()
  private func unpackParties() throws -> [Party] {
    let data = try contentsOf(resource: "Parties", extension: "json")
    let decoder = JSONDecoder()
    return try decoder.decode([Party].self, from: data)
  }
  private func unpackPerformances() throws -> [Performance] {
    let data = try contentsOf(resource: "Performances", extension: "json")
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dobDateFormatter)
    return try decoder.decode([Performance].self, from: data)
  }
  private let dobDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d/M/yyyy"
    return dateFormatter
  }()
  private func contentsOf(resource r: String, extension e: String) throws -> Data {
    let bundle = Bundle(for: Database.Event.self)
    let url = bundle.url(forResource: r, withExtension: e)!
    return try String(contentsOf: url).data(using: .utf8)!
  }
  struct Event: Decodable, Recordable {
    let startDate: Date
    enum CodingKeys: String, CodingKey {
      case startDate = "StartDate"
    }
    var primaryKey: Database.Event.Query? {
      return Database.Event.Query(startDate: startDate)
    }
    func update(record: Database.Event) {
      record.startDate = startDate
    }
  }
  struct Party: Decodable, Recordable {
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
    var partyType: Database.Party.PartyType {
      return Database.Party.PartyType(rawValue: type)!
    }
    var primaryKey: Database.Party.Query? {
      return Database.Party.Query(email: email, name: name, phone: phone, type: partyType)
    }
    func update(record: Database.Party) {
      record.email = email
      record.name = name
      record.phone = phone
      record.type_ = partyType
    }
  }
  struct Performer: Decodable {
    struct Export: Recordable {
      let firstName: String
      let lastName: String
      let dob: Date
      let party: Database.Party
      /// There may be performers with identical details between parties and they may be the same person.
      /// Performers may change parties over time and we wouldn't know.
      /// Or performers may have the same details by coinsidence.
      /// So have decided to create a single record per performer per party.
      var primaryKey: Database.Performer.Query? {
        return Database.Performer.Query(dob: dob, firstName: firstName, lastName: lastName, party: party)
      }
      func update(record: Database.Performer) {
        record.party = party
        record.dob = dob
        record.firstName = firstName
        record.lastName = lastName
      }
    }
    let firstName: String
    let lastName: String
    let dob: Date
    enum CodingKeys: String, CodingKey {
      case firstName = "First Name"
      case lastName = "Last Name"
      case dob = "D.O.B"
    }
    func export(withParty party: Database.Party) -> Export {
      return Export(firstName: firstName, lastName: lastName, dob: dob, party: party)
    }
  }
  struct Performance: Decodable {
    struct Export: Recordable {
      let ability: Database.Performance.Ability
      let group: Database.Performance.Group
      let performers: Set<Database.Performer>
      let event: Database.Event
      let aggregate: Aggregate<Database.Performer>.Operator = .allMatching
      var primaryKey: Database.Performance.Query? {
        let restriction = Aggregate<Database.Performer>(aggregate, records: performers)
        return Database.Performance.Query(performers: restriction, event: event, ability: ability, group: group)
      }
      func update(record: Database.Performance) {
        record.event = event
        record.performers = performers
        record.ability_ = ability
        record.group_ = group
      }
      init(ability: Database.Performance.Ability, group: Database.Performance.Group, performers: Set<Database.Performer>, event: Database.Event) {
        self.ability = ability
        self.group = group
        self.performers = performers
        self.event = event
      }
    }
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
      let ability = try values.decode(String.self, forKey: .ability)
      let group = try values.decode(String.self, forKey: .group)
      let performers = try values.decode([DataBuilder.Performer].self, forKey: .performers)
      self.init(ability: ability, group: group, performers: performers)
    }
    init(ability: String, group: String, performers: [Performer]) {
      self.ability = ability
      self.group = group
      self.performers = performers
    }
    func export(withEvent event: Database.Event, withParty party: Database.Party, withContext context: NSManagedObjectContext) throws -> Export {
      let performers_: [Database.Performer] = try performers.map {
        let export = $0.export(withParty: party)
        let record = try export.record(in: context)
        return record
      }
      let ability_ = Database.Performance.Ability(rawValue: ability)!
      let group_ = Database.Performance.Group(rawValue: group)!
      return Export(ability: ability_, group: group_, performers: Set(performers_), event: event)
    }
  }
}

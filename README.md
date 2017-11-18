<p align="center">
    <img src="Logo.png" width="480" max-width="90%" alt="Records" />
</p>

<p align="center">
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat" alt="Carthage" />
    </a>
    <a href="https://cocoapods.org">
        <img src="https://img.shields.io/badge/cocoapods-compatible-4BC51D.svg?style=flat" alt="Cocoapods" />
    </a>
    <a href="https://travis-ci.org/rob-nash/records">
        <img src="https://travis-ci.org/rob-nash/Records.svg?branch=master" alt="Build" />
    </a>
    <a href="https://developer.apple.com/swift/">
        <img src="https://img.shields.io/badge/language-Swift%204.0-4BC51D.svg?style=flat" alt="Swift" />
    </a>
    <a href="https://developer.apple.com">
        <img src="https://img.shields.io/badge/platform-iOS%2010%2B-blue.svg?style=flat" alt="Platform: iOS" />
    </a>
    <a href="https://twitter.com/nashytitz">
        <img src="https://img.shields.io/badge/contact-@nashytitz-blue.svg?style=flat" alt="Twitter: @nashytitz" />
    </a>
</p>

A lightweight convenience API for basic CoreData database tasks. Run the `RecordsDemo` Xcode scheme for a demonstration. 

*Scalar or transformable types not supported*

## Usage

Consider the following database schema.

<p align="center">
    <a href="https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/KeyConcepts.html">
        <img src="https://i.imgur.com/WRlhnlK.png" alt="CoreData" />
    </a>
</p>

A class for entity 'Performer', may look like the following.

```swift
import Foundation
import CoreData
import Records

@objc(Performer)
public class Performer: NSManagedObject, Fetchable {

  @NSManaged public var dob: Date
  
  @NSManaged public var firstName: String
  
  @NSManaged public var lastName: String
  
  @NSManaged public var party: Party
  
  @NSManaged public var performances: Set<Performance>?

}

// sourcery:inline:Performer.ManagedObject.Query.stencil
// sourcery:end
```

By declaring conformance to `Fetchable` and adding annotation marks for sourcery, the following auto-completing syntax is at your disposal (after you compile).

```swift
let query = Performer.Query(dob: nil, firstName: "Maggie", lastName: nil, party: nil, performances: nil) // Fetch all with first name that BEGINSWITH[cd] `Maggie`
let performers: [Performer] = try! query.all(in: context)
```

Enjoy!

But wait?...sourcery? 🤔

## Sourcery

[Sourcery](https://github.com/krzysztofzablocki/Sourcery) is a boiler-plate generation tool that you can optionally use with this framework. A pre-written stencil file is provided [here](https://github.com/rob-nash/Records/blob/master/Database/Templates/ManagedObject.Query.stencil) which will instruct soucery to write the 'Query' syntax for any NSManagedObject subclass that implements `Fetchable`.

Any change you make to your CoreData schema will trigger the regeneration of boiler-plate code. So for instance, if you removed the property `lastName` from `Performer` the new initialiser will be as follows.

```swift
let query = Performer.Query(dob: nil, firstName: "Maggie", party: nil, performances: nil)
let performers: [Performer] = try! query.all(in: context)
```

The Xcode compiler will highlight the changed initialiser at compile time. It's useful to individually evaluate each call site effected by your schema changes.

## Other Features

Take a look at the source in the `RecordsDemo` target for more details on these features.

To-Many relationship queries.

```swift
let restriction = RelationshipRestriction(operation: .allMatching, records: Set(arrayLiteral: performerA, performerB))
let query = Performance.Query(performers: restriction, event: nil, ability: nil, group: nil)
let performances: [Performance] = try! query.all(in: context)
```

Null predicate searching.

```swift
let performer: Performer? = try! Performer.fetchFirst(in: context)
let performer: Performer? = try! Performer.fetchFirst(in: context, sortedBy: NSSortDescriptor(key: "firstName", ascending: true))
```

Custom predicates are still available.

```swift
let performers: [Performer] = try! Performer.fetchAll(withPredicate: NSPredicate(format: "firstName CONTAINS[cd] %@", "Maggie"), in: context)
```

Small UIViewController subclasses.

```swift
import UIKit

class PerformancesViewController: UIViewController {
  
  var fetchedResultsController: PerformancesFetchedResultsController!
  
  @IBOutlet private weak var tableView: PerformancesTableView! {
    didSet {
      fetchedResultsController.delegate = tableView
      fetchedResultsController.dataSource = tableView
      tableView.dataSource = fetchedResultsController
      tableView.delegate = fetchedResultsController
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Performances"
    fetchedResultsController.selectPerformance = { performance in
      /// do something
    }
  }
  
}
```

String replacement with Enum.

```swift
let query = Party.Query(email: email, name: name, phone: phone, performers: nil, type: .school)
```

To use an enum set the string property on your Entity subclass to private. Then create a `var` for your enum.

```swift
import Foundation
import CoreData
import Records

@objc(Party)
public class Party: NSManagedObject, Fetchable {
  
  @NSManaged public var email: String
  
  @NSManaged public var name: String
  
  @NSManaged public var phone: String
  
  @NSManaged private var type: String
  
  @NSManaged public var performers: Set<Performer>?
  
  public enum PartyType: String {
    case school = "School"
    case independent = "Independent"
  }
  
  public var type_: PartyType {
    get {
      return PartyType(rawValue: type)!
    }
    set {
      type = newValue.rawValue
    }
  }
  
}
```

Make sure to set a default value on the property and write a unit test ([see here](https://github.com/rob-nash/Records/blob/master/RecordsTests/PartyTests.swift)).

## Installing

For the latest release, select the [release](https://github.com/rob-nash/Records/releases) tab.

### Carthage:

Add `github "rob-nash/Records"` to your `Cartfile`.

### Cocoapods:

Add `pod "Records"` to your `Podfile`.

### Donations.
<p>If you like this and you want to buy me a drink, use bitcoin.</p>

![Bitcoin Image](Resources/Bitcoin.jpg)

Bitcoin Address: 15Gj4DBTzSujnJrfRZ6ivrR9kDnWXNPvNQ

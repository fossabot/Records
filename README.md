<p align="center">
    <img src="Logo.png" width="480" max-width="90%" alt="Records" />
</p>

<p align="center">
    <a href="https://travis-ci.org/rob-nash/records">
        <img src="https://travis-ci.org/rob-nash/Records.svg?branch=master" alt="Build" />
    </a>
    <a href="https://twitter.com/nashytitz">
        <img src="https://img.shields.io/badge/contact-@nashytitz-blue.svg?style=flat" alt="Twitter: @nashytitz" />
    </a>
</p>

A lightweight convenience API for basic CoreData database tasks.

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

By declaring conformance to `Fetchable`, adding annotation marks for sourcery and settings codgen to 'manual', the following auto-completing syntax is at your disposal (once you compile with cmd + b).

```swift
// Query all for first name that BEGINSWITH[cd] `Maggie` ignoring other attributes.
let query = Performer.Query(dob: nil, firstName: "Maggie", lastName: nil, party: nil, performances: nil)
```

Queries can then be executed in various ways. Such as 'fetch all'.

```swift
do {
  let performers: [Performer] = try query.all(in: context)
  if performers.count == 0 { print("none found") }
} catch {
  // Errors from the CoreData layer such as 'model not found' etc
}
```

Custom predicates are still available.

```swift
let performers: [Performer] = try! Performer.fetchAll(withPredicate: NSPredicate(format: "firstName CONTAINS[cd] %@", "Maggie"), in: context)
```

Any change you make to your CoreData schema will trigger the regeneration of boiler-plate code. So for instance, if you removed the property `lastName` from the entity `Performer` the new initialiser will be as follows (once you compile with cmd + b).

```swift
let query = Performer.Query(dob: nil, firstName: "Maggie", party: nil, performances: nil)
let performers: [Performer] = try! query.all(in: context)
```

The Xcode compiler will highlight the changed initialiser at compile time. It's useful to individually evaluate each call site effected by your schema changes.

Create a record using the usual CoreData API.

```swift
let performer = Performer(context: context)
```

Enjoy!

But wait?...sourcery? 🤔

## Sourcery

[Sourcery](https://github.com/krzysztofzablocki/Sourcery) is a boiler-plate generation tool that you can optionally use with this framework. 

A pre-written stencil file is provided [here](https://github.com/rob-nash/Records/blob/master/Database/Templates/ManagedObject.Query.stencil) which will instruct soucery to write the 'Query' syntax for any NSManagedObject subclass that implements `Fetchable`.

## Other Features

Checkout [Performances](https://github.com/rob-nash/Performances) for an example implementation of these features.

To-Many relationship queries.

```swift
let restriction = RelationshipRestriction(operation: .allMatching, records: Set(arrayLiteral: performerA, performerB))
let query = Performance.Query(performers: restriction, event: nil, ability: nil, group: nil)
let performances: [Performance] = try! query.all(in: context)
```

<p align="left"><img src="http://i.giphy.com/3oFzm3dzbxVd2FNJrW.gif" width="252" height="395"/></p>

Null predicate searching.

```swift
let performer: Performer? = try! Performer.fetchFirst(in: context)
let performer: Performer? = try! Performer.fetchFirst(in: context, sortedBy: NSSortDescriptor(key: "firstName", ascending: true))
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

When switching the accessibility level of your @NSManaged vars from public to private, like the above enum example, it is recommended that you use an underscore, because the script will truncate the underscore from the initialiser. If you would like to use some other naming convention, feel free to modify [the script](https://github.com/rob-nash/Records/blob/master/Database/Templates/ManagedObject.Query.stencil).

## Installing

For the latest release, select the [release](https://github.com/rob-nash/Records/releases) tab.

### Carthage:

Add `github "rob-nash/Records"` to your `Cartfile`.

### Donations.
<p>If you like this and you want to buy me a drink, use bitcoin.</p>

![Bitcoin Image](Resources/Bitcoin.jpg)

Bitcoin Address: 15Gj4DBTzSujnJrfRZ6ivrR9kDnWXNPvNQ

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

*Transformable types not supported*

Checkout [Performances](https://github.com/rob-nash/Performances) for an example implementation.

## Example Usage

Assume `Performer` is a CoreData entity.

```swift
do {
  let performers = try Performer.fetchAll(in: context)
} catch {
  // Errors from the CoreData layer such as 'model not found' etc
}
```

```swift
do {
  // All records with first name BEGINSWITH[cd] `Maggie`
  let performers: [Performer] = try Performer.Query(firstName: "Maggie").all(in: context)
} catch {
  // Errors from the CoreData layer such as 'model not found' etc
}
```

```swift
do {
  let query = Performer.Query(firstName: "Maggie")
  let sorts = [NSSortDescriptor(key: "firstName", ascending: true)]
  let performer: Performer? = try query.first(in: context, sortedBy: sorts)
} catch {
  // Errors from the CoreData layer such as 'model not found' etc
}
```

Create a record using the usual CoreData API.

```swift
let performer = Performer(context: context)
```

To-Many relationship queries.

```swift
let aggregate = Aggregate<Performer>(.allMatching, records: Set([performerA, performerB]))
let query = Performance.Query(performers: aggregate)
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
  
  private let fetchedResultsController: PerformancesFetchedResultsController!
  
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
    try! fetchedResultsController.reload()
  }
  
}
```

**1. Installation**
   
  [<img width="300" alt="screen shot" src="https://img.youtube.com/vi/31CfpBJNAJc/0.jpg">](https://www.youtube.com/watch?v=31CfpBJNAJc)

**2. Usage**

  [<img width="300" alt="screen shot" src="https://img.youtube.com/vi/HOTwBou6FB4/0.jpg">](https://www.youtube.com/watch?v=HOTwBou6FB4)

## Installing

Checkout [Performances](https://github.com/rob-nash/Performances) to see a fully configured installation.

For the latest release, select the [release](https://github.com/rob-nash/Records/releases) tab.

Manually install the following. Can be done easily with [Homebrew](https://brew.sh).

* [Carthage](https://github.com/Carthage/Carthage) v0.29.0+
* [Sourcery](https://github.com/krzysztofzablocki/Sourcery) v0.11.0+

Add the following to your `Cartfile`.

```
github rob-nash/Records
```

Consider the following database schema.

<p align="center">
    <a href="https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/KeyConcepts.html">
        <img src="https://i.imgur.com/WRlhnlK.png" alt="CoreData" />
    </a>
</p>

## Steps

* Setup sourcery.
* Setup NSManagedObjects.
* Compile your code.

Create the following at the root directory of your project.

```
./.sourcery.yml
```

If you installed `Records` using Carthage, then the contents of .sourcery.yml file should be like the following.

```
sources:
- ../Carthage/Checkouts/Records/Records
- ./Path/To/Your/NSManagedObject/Subclasses
templates:
- ../Carthage/Checkouts/Records/Database/Templates
output:
- ./Path/To/Your/NSManagedObject/Subclasses
```

A class for entity 'Performer', should look like the following.

```swift
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

* Declare conformance to `Fetchable` in each of your NSManaged object suclasses.
* Add annotation marks for sourcery in each of your NSManaged object suclasses.
* Set codgen to 'manual' for each of your CoreData entities.

Then hit build and compile your code! Done!

Checkout [Performances](https://github.com/rob-nash/Performances) to see a fully configured installation.

## Footnote

String replacement with Enum.

```swift
let query = Party.Query(type: .school)
```

To use an enum set the string property on your Entity subclass to private. Then create a `var` for your enum.

```swift
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

If you write custom properties on classes targetted by Sourcery you may want to use the following annotation.

```swift
public extension Performer {
  
  //sourcery:sourcerySkip
  var fullName: String {
    return firstName + " " + lastName
  }
```

### Donations.
<p>If you like this and you want to buy me a drink, use bitcoin.</p>

![Bitcoin Image](Resources/Bitcoin.jpg)

Bitcoin Address: 15Gj4DBTzSujnJrfRZ6ivrR9kDnWXNPvNQ

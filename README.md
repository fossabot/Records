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

A lightweight convenience API for basic CoreData database tasks. As you develop your project and make changes to your CoreData schema, boiler plate code is automatically re-written for you. Checkout [Performances](https://github.com/rob-nash/Performances) for a fully configured installation and a demo.

Consider the following database schema.

<p align="center">
<a href="https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/KeyConcepts.html">
<img src="https://i.imgur.com/WRlhnlK.png" alt="CoreData" />
</a>
</p>

<details>
<summary>Installation</summary>
</br>
<p>Install the following. <a href="https://brew.sh">Homebrew</a> is your friend.</p>

<p align="left">
<a href="https://github.com/krzysztofzablocki/Sourcery">
<img src="https://img.shields.io/badge/sourcery-0.11.0+-green.svg?style=flat" alt="Sourcery: 0.11.0+" />
</a>
<a href="https://github.com/Carthage/Carthage">
<img src="https://img.shields.io/badge/carthage-0.29.0+-green.svg?style=flat" alt="Carthage: 0.29.0+" />
</a>
<a href="https://swift.org">
<img src="https://img.shields.io/badge/swift-4+-green.svg?style=flat" alt="Swift: 4+" />
</a>
<a href="https://developer.apple.com">
<img src="https://img.shields.io/badge/xcode-9+-green.svg?style=flat" alt="Xcode: 9+" />
</a>
</p>

<p>Add the following to your `Cartfile`.</p>

<pre><code class="swift language-swift">github rob-nash/Records</code></pre>

<p>Run the following.</p>

<pre><code class="swift language-swift">carthage update</code></pre>

<p>Once the <code>Records</code> binary is built, link it to your project.<p>
<p>For the latest release, select the <a href="https://github.com/rob-nash/Records/releases">Releases</a> tab.

</br>
<p>Create the following at the root directory of your project.</p>

<pre><code class="swift language-swift">./.sourcery.yml</code></pre>

<p>This <code>sourcery.yml</code> file should contain the following.</p>

<pre><code class="swift language-swift">
sources:
- ./Path/To/Your/NSManagedObject/Subclasses
templates:
- ../Carthage/Build/iOS/Records.framework/
output:
./Path/To/Your/NSManagedObject/Subclasses
</code></pre>

<p>Run the following as a build phase, just before the build phase named 'compile sources'.</p>

<pre><code class="swift language-swift">sourcery --config ./.sourcery.yml</code></pre>

<p>In your core data model file, set codgen to 'manual' for each of your CoreData entities.</p>
<p>All of your NSManagedObject subclasses shoud be configured in the following way. Let's look at <code>Performer</code>, as an example.</p>

<pre><code class="swift language-swift">
import CoreData
import Records

@objc(Performer)
public class Performer: NSManagedObject, Fetchable {
@NSManaged public var dob: Date
@NSManaged public var firstName: String
@NSManaged public var lastName: String
@NSManaged public var party: Party
//@NSManaged public var performances: NSSet?
@NSManaged public var performances: Set&lt;Performance&gt;?
}

// sourcery:inline:Performer.ManagedObject.Query.stencil
// sourcery:end
</code></pre>

<p>Notice the following.</p>
<ul>
<li>Declared conformance to `Fetchable` in each of your entity suclasses.</li>
<li>Added annotation marks for Sourcery.</li>
<li>Changed type <code>NSSet</code> to <code>`Set&lt;Performance&gt;</code></li>
</ul>
</details>

## Example Fetch

Fetch all records.

```swift
do {
  let performers = try Performer.fetchAll(in: context)
} catch {
  // Errors from the CoreData layer such as 'model not found' etc
}
```

```swift
do {
  // Initialiser param `firstName` is automatic boiler plate and 
  // changes in response to changes in your schema as your develop your project
  // Default for string is BEGINSWITH[cd] `Maggie`. Change by using `Performer.fetchAll(withPredicate: in: )` instead.
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

<img align="right" src="http://i.giphy.com/3oFzm3dzbxVd2FNJrW.gif" width="252" height="395"/>

Query using relationships as constraints.

```swift
// Find performances 
// which include performers:
// Performer 1
// Performer 2
// Both of them .allMatching, 
// Some of them .someMatching
// Or neither of them .noneMatching
let aggregate = Aggregate<Performer>(.allMatching, records: Set([performer1, performer2]))
let query = Performance.Query(performers: aggregate)
let performances: [Performance] = try! query.all(in: context)
```
## Example Create

Create a record using the usual CoreData API.

```swift
let performer = Performer(context: context)
```

Or create a unique core data record, from a dataset.

```swift
// Data for a party
struct SomeData {
    let name: String
    let phone: String
    let email: String
    let type: String
}

extension SomeData: Recordable {
    // A query that is guaranteed to return a unique value.
    // Think carefully about this implementation
    // Write tests: see footnote below about robust recordable implementations
    var primaryKey: Party.Query? {
        return Party.Query(email: email, name: name, phone: phone, type: Party.PartyType(rawValue: type)!)
    }
    func update(record: Party) {
        record.email = email
        record.name = name
        record.phone = phone
        record.type_ = Party.PartyType(rawValue: type)!
    }
}

let data = SomeData(name: "DanceSchool", phone: "01234567891", email: "dance@school.com", type: "School")

do {
    let record: Party = try data.record(in: context)
} catch {
    // Errors from the CoreData layer such as 'model not found' etc
}
```

A more complex example, that uses a relationship named `party` as a query constraint.

```swift
//Data for a performer that belongs to a specific party.
struct SomeData {
    let firstName: String
    let lastName: String
    let dob: Date
    struct Export: Recordable {
        let firstName: String
        let lastName: String
        let dob: Date
        let party: Party
        // A query that is guaranteed to return a unique value.
        // Think carefully about this implementation
        // Write tests: see footnote below about robust recordable implementations
        var primaryKey: Performer.Query? {
            return Performer.Query(dob: dob, firstName: firstName, lastName: lastName, party: party)
        }
        func update(record: Performer) {
            record.party = party
            record.dob = dob
            record.firstName = firstName
            record.lastName = lastName
        }
    }
    func export(withParty party: Party) -> Export {
        return Export(firstName: firstName, lastName: lastName, dob: dob, party: party)
    }
}

let data = SomeData(firstName: "Rob", lastName: "Nash", dob: Date())
let export = data.export(withParty: party)
do {
    let record: Performer = try export.record(in: context)
} catch {
    // Errors from the CoreData layer such as 'model not found' etc
}
```

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

## Footnote

*Transformable types not supported*

<details>
<summary>String replacement with Enum</summary>
</br>
<pre><code class="swift language-swift">
let query = Party.Query(type: .school)
</code></pre>
<p>To use an enum set the string property on your Entity subclass to private. Then create a `var` for your enum.</p>
<pre><code class="swift language-swift">
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
</code></pre>
<p>Make sure to set a default value on the property and write a unit test (<a href="https://github.com/rob-nash/Records/blob/master/RecordsTests/PartyTests.swift">see here</a>).</p>
</details>
<br>
<details>
<summary>The underscore_ convention</summary>
</br>
<p>When switching the accessibility level of your @NSManaged vars from public to private, like the above enum example, it is recommended that you use an underscore, because the script will truncate the underscore from the initialiser. If you would like to use some other naming convention, feel free to modify <a href="https://github.com/rob-nash/Records/blob/master/Database/Templates/ManagedObject.Query.stencil">the script</a>.</p>
</details>
<br>
<details>
<summary>Preventing boiler plate generation</summary>
</br>
<p>If you write custom properties on classes targetted by Sourcery you may want to use the following annotation.</p>
<pre><code class="swift language-swift">
public extension Performer {
  
  //sourcery:sourcerySkip
  var fullName: String {
    return firstName + " " + lastName
  }
</code></pre>
</details>
<br>
<details>
<summary>Robust Recordable implementations</summary>
</br>
<p>When implementing the `Recordable` protocol, it is a good idea to implement a test to ensure `update(record: NSManagedObject)` is robust.</p>
<pre><code class="swift language-swift">
func testCreateEventRecord() throws {
    let date = Date()
    let data = DataBuilder.Event(startDate: date)
    let context = persistentContainer.viewContext
    let record: Database.Event = try data.record(in: context)
    XCTAssertTrue(record.startDate == date, "Incorrect start date of \(record.startDate). Actual \(date).")
}
</code></pre>
</details>

The following videos are slightly out of date but still good.

**1. Installation**
   
  [<img width="300" alt="screen shot" src="https://img.youtube.com/vi/31CfpBJNAJc/0.jpg">](https://www.youtube.com/watch?v=31CfpBJNAJc)

**2. Usage**

  [<img width="300" alt="screen shot" src="https://img.youtube.com/vi/HOTwBou6FB4/0.jpg">](https://www.youtube.com/watch?v=HOTwBou6FB4)

### Donations.
<p>If you like this and you want to buy me a drink, use bitcoin.</p>

![Bitcoin Image](Resources/Bitcoin.jpg)

Bitcoin Address: 15Gj4DBTzSujnJrfRZ6ivrR9kDnWXNPvNQ

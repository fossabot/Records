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
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-4+-green.svg?style=flat" alt="Swift: 4+" />
    </a>
    <a href="https://developer.apple.com">
        <img src="https://img.shields.io/badge/xcode-9+-green.svg?style=flat" alt="Xcode: 9+" />
    </a>
</p>

A lightweight convenience API for basic CoreData database tasks. 

As you develop your project and make changes to your CoreData schema, boiler plate code is automatically re-written for you. 

*Transformable types not supported*

## Usage

Consider the following database schema

<p align="center">
<a href="https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/KeyConcepts.html">
<img src="https://i.imgur.com/WRlhnlK.png" alt="CoreData" />
</a>
</p>

[Fetch API](https://github.com/rob-nash/Records/wiki/Fetching)

```swift
do {
  let performers = try Performer.fetchAll(in: context)
} catch {
  // Errors from the CoreData layer such as 'model not found' etc
}
```

[Create API](https://github.com/rob-nash/Records/wiki/Create)

```swift
struct SomeData {
    let name: String
    let phone: String
    let email: String
    let type: String

    // implement `Recordable` here
}

let data = SomeData(name: "DanceSchool", phone: "01234567891", email: "dance@school.com", type: "School")

do {
    let record: Party = try data.record(in: context)
} catch {
    // Errors from the CoreData layer such as 'model not found' etc
}
```

[Observe API](https://github.com/rob-nash/Records/wiki/Observe)

```swift
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
    try! fetchedResultsController.reload()
  } 
}
```

## Footnotes

See [footnotes](https://github.com/rob-nash/Records/wiki/Footnotes) for some handy tips.

## Demo

Checkout [Performances](https://github.com/rob-nash/Performances) for a fully configured installation and a demo.

## Installation

<p>Install the following. <a href="https://brew.sh">Homebrew</a> is your friend.</p>
<p align="left">
<a href="https://github.com/krzysztofzablocki/Sourcery">
<img src="https://img.shields.io/badge/sourcery-0.11.0+-green.svg?style=flat" alt="Sourcery: 0.11.0+" />
</a>
<a href="https://github.com/Carthage/Carthage">
<img src="https://img.shields.io/badge/carthage-0.29.0+-green.svg?style=flat" alt="Carthage: 0.29.0+" />
</a>
</p>

Add the following to your `Cartfile`.

```
github rob-nash/Records
```

For the latest release, select the [Releases](https://github.com/rob-nash/Records/releases) tab.

To setup Sourcery, follow [these steps](https://github.com/rob-nash/Records/wiki/Setting-up-Sourcery).

## Tutorials

The following videos are slightly out of date but still good.

**1. Installation**
   
  [<img width="300" alt="screen shot" src="https://img.youtube.com/vi/31CfpBJNAJc/0.jpg">](https://www.youtube.com/watch?v=31CfpBJNAJc)

**2. Usage**

  [<img width="300" alt="screen shot" src="https://img.youtube.com/vi/HOTwBou6FB4/0.jpg">](https://www.youtube.com/watch?v=HOTwBou6FB4)

### Donations.
<p>If you like this and you want to buy me a drink, use bitcoin.</p>

![Bitcoin Image](https://github.com/rob-nash/Records/blob/master/Resources/Bitcoin.jpg)

Bitcoin Address: 15Gj4DBTzSujnJrfRZ6ivrR9kDnWXNPvNQ

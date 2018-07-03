<p align="center">
    <img src="Logo.png" width="480" max-width="90%" alt="Records" />
</p>

<p align="center">
    <a href="https://travis-ci.org/rob-nash/Records">
        <img src="https://travis-ci.org/rob-nash/Records.svg?branch=master" alt="Build" />
    </a>
    <a href="https://twitter.com/nashytitz">
        <img src="https://img.shields.io/badge/contact-@nashytitz-blue.svg?style=flat" alt="Twitter: @nashytitz" />
    <a href="https://codebeat.co/projects/github-com-rob-nash-records-master">
    	<img alt="codebeat badge" src="https://codebeat.co/badges/94dfa117-7d48-451d-bff9-81117efe5032" />
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-4.1-green.svg?style=flat" alt="Swift: 4.1" />
    </a>
    <a href="https://developer.apple.com">
        <img src="https://img.shields.io/badge/xcode-9+-green.svg?style=flat" alt="Xcode: 9+" />
    </a>
</p>

A very light-weight **CoreData** wrapper that **dynamically re-writes itself**, as you develop your project. The type safe nature of swift ensures that **every query has a result**. There are **no errors thrown for queries** per se. For error handling see CoreData documentation.

<p align="center">
<a href="https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/KeyConcepts.html">
<img src="https://i.imgur.com/WRlhnlK.png" alt="CoreData" />
</a>
</p>

## Fetch

In the following example, if zero `solo` performances are stored then the returned result will be an empty array.

```swift
do {
  let performances: [Performance] = try Performance.Query(group: .solo).all(in: context)
  performances.forEach { (performance) in
    context.delete(performance)
  }
  try context.save()
} catch {
  // Errors from the CoreData layer such as 'model not found' etc
}
```

[More Fetch API](https://github.com/rob-nash/Records/wiki/Fetching)

## Create

When using `Recordable` we ensure the following.

1. If a record does not exist for this data, it is created.
2. If a record does exist, it is found and updated.

```swift
struct SomeData {
    let name: String
    let phone: String
    let email: String
    let type: String

    // implement `Recordable` here ~ 2 minutes
}

let data = SomeData(name: "DanceSchool", phone: "01234567891", email: "dance@school.com", type: "School")

do {
    let record: Party = try data.record(in: context)
} catch {
    // Errors from the CoreData layer such as 'model not found' etc
}
```

[More Create API](https://github.com/rob-nash/Records/wiki/Create)

## Observe

The following tableView is connected to an NSFetchedResultsController and UI changes are delegated to a default protocol implementation.

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

[More details](https://github.com/rob-nash/Records/wiki/Observe)

## Installation

Add the following to your `Cartfile`.

```
github rob-nash/Records
```

For the latest release, select the [Releases](https://github.com/rob-nash/Records/releases) tab.

## Dependencies 

* [Sourcery](http://brewformulas.org/sourcery) 
* [Carthage](http://brewformulas.org/Carthage)

To configure Sourcery, follow [these steps](https://github.com/rob-nash/Records/wiki/Setting-up-Sourcery) ~ 2 minutes.

## Demo

Checkout [Performances](https://github.com/rob-nash/Performances) for a fully configured installation and a demo.

## Footnotes

See [footnotes](https://github.com/rob-nash/Records/wiki/Footnotes) for some handy tips.

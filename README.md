<p align="center">
    <img src="Logo.png" width="480" max-width="90%" alt="Records" />
</p>

<p align="center">
    <a href="https://travis-ci.org/rob-nash/Records">
        <img src="https://travis-ci.org/rob-nash/Records.svg?branch=master" alt="Build"/>
    </a>
    <a href="https://img.shields.io/badge/carthage-compatible-brightgreen.svg">
        <img src="https://img.shields.io/badge/carthage-compatible-brightgreen.svg" alt="Carthage"/>
    </a>
<a href="https://app.fossa.io/projects/git%2Bgithub.com%2Frob-nash%2FRecords?ref=badge_shield" alt="FOSSA Status"><img src="https://app.fossa.io/api/projects/git%2Bgithub.com%2Frob-nash%2FRecords.svg?type=shield"/></a>
    <a href="https://codebeat.co/projects/github-com-rob-nash-records-master">
    	<img alt="codebeat badge" src="https://codebeat.co/badges/94dfa117-7d48-451d-bff9-81117efe5032"/>
    </a>
    <a href="https://twitter.com/nashytitz">
        <img src="https://img.shields.io/badge/contact-@nashytitz-blue.svg?style=flat" alt="Twitter: @nashytitz"/>
    </a>
</p>

A very light-weight **CoreData** wrapper that **dynamically re-writes itself**, as you develop your project.

<p align="center">
<a href="https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/KeyConcepts.html">
<img src="https://i.imgur.com/WRlhnlK.png" alt="CoreData" />
</a>
</p>

## Fetch

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

[More details](https://github.com/rob-nash/Records/wiki/Fetching)

## Create

```swift
struct Information {
    let name: String
    let phone: String
    let email: String
    let type: String

    // implement protocol named `Recordable` here ~ 2 minutes
}

let info = Information(name: "DanceSchool", phone: "01234567891", email: "dance@school.com", type: "School")

do {
    let record: Party = try info.record(in: context)
} catch {
    // Errors from the CoreData layer such as 'model not found' etc
}
```

When using the protocol named `Recordable` we ensure the following is performed when we call `record(in: )`.

1. If a record does not exist that matches this data, it is created.
2. If a record does exist that matches this data, it is retrieved.

[More details](https://github.com/rob-nash/Records/wiki/Create)

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

1. Run the [Carthage](https://github.com/Carthage/Carthage#installing-carthage) command `carthage update`.
2. Embed Binary.
3. Install [Sourcery](https://github.com/krzysztofzablocki/Sourcery#installation).
4. Adjust NSManagedObject subclasses `~2 minute job`.

[See Guide](https://github.com/rob-nash/Records/wiki/Installation)

## Demo

1. Run the [Carthage](https://github.com/Carthage/Carthage#installing-carthage) command `carthage bootstrap`.
2. Install [Sourcery](https://github.com/krzysztofzablocki/Sourcery#installation).
3. Run the Xcode scheme named `Performances`.

## Footnotes

See [footnotes](https://github.com/rob-nash/Records/wiki/Footnotes) for some handy tips.


## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Frob-nash%2FRecords.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Frob-nash%2FRecords?ref=badge_large)
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
  let performances = try Performance.Query(group: .solo).all(in: context)
  performances.forEach { (performance) in
    context.delete(performance)
  }
  try context.save()
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

Add the following to your `Cartfile`.

```
github rob-nash/Records
```

For the latest release, select the [Releases](https://github.com/rob-nash/Records/releases) tab.

## Dependencies 

* [Sourcery](http://brewformulas.org/sourcery) 
* [Carthage](http://brewformulas.org/Carthage)

To setup Sourcery, follow [these steps](https://github.com/rob-nash/Records/wiki/Setting-up-Sourcery).

## Tutorials

The following videos are slightly out of date but still good.

**1. Installation**
   
  [<img width="300" alt="screen shot" src="https://img.youtube.com/vi/31CfpBJNAJc/0.jpg">](https://www.youtube.com/watch?v=31CfpBJNAJc)

**2. Usage**

  [<img width="300" alt="screen shot" src="https://img.youtube.com/vi/HOTwBou6FB4/0.jpg">](https://www.youtube.com/watch?v=HOTwBou6FB4)

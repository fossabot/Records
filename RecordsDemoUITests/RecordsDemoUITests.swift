//
//  RecordsDemoUITests.swift
//  RecordsDemoUITests
//
//  Created by Robert Nash on 21/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import XCTest

class RecordsDemoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
  
    /// Checking the UI loads
    func testMe() {
      let app = XCUIApplication()
      let tablesQuery = app.tables
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["FetchedResultsController1"]/*[[".cells.staticTexts[\"FetchedResultsController1\"]",".staticTexts[\"FetchedResultsController1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["23 performances registered"]/*[[".cells.staticTexts[\"23 performances registered\"]",".staticTexts[\"23 performances registered\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      app.buttons["29 performers registered"].tap()
      
      let performersNavigationBar = app.navigationBars["Performers"]
      performersNavigationBar.buttons["Summary"].tap()
      app.buttons["23 performances registered"].tap()
      app.navigationBars["Performances"].buttons["Summary"].tap()
      app.navigationBars["Summary"].buttons["Events"].tap()
      app.navigationBars["Events"].buttons["Back"].tap()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["FetchedResultsController2"]/*[[".cells.staticTexts[\"FetchedResultsController2\"]",".staticTexts[\"FetchedResultsController2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      app.navigationBars["Filter"].buttons["Back"].tap()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Query specific property"]/*[[".cells.staticTexts[\"Query specific property\"]",".staticTexts[\"Query specific property\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      performersNavigationBar.buttons["Back"].tap()
      tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Query To-Many Relationship"]/*[[".cells.staticTexts[\"Query To-Many Relationship\"]",".staticTexts[\"Query To-Many Relationship\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      app.navigationBars["RecordsDemo.RelationshipRestrictionView"].buttons["Back"].tap()
    }
    
}

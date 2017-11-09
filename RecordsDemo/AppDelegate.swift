//
//  AppDelegate.swift
//  RecordsDemo
//
//  Created by Robert Nash on 21/10/2017.
//  Copyright © 2017 Robert Nash. All rights reserved.
//

import UIKit
import Database

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    let context = Storage.sharedInstance.persistentContainer.viewContext
    DataBuilder(context: context).populateDatabase()
    try! context.save()    
    return true
  }

}

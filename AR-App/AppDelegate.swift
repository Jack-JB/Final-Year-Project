//
//  AppDelegate.swift
//  AR-App
//
//  Created by Jack Burrows on 27/01/2023.
//

import UIKit
import SwiftUI
import FirebaseCore

// Entry point to the application
@main
struct MyApp: App {
  
  init() {
    // Implement Firebase
    FirebaseApp.configure()
  }
    var body: some Scene {
        WindowGroup {
            // Call the starting point function
            HomeView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Set up the SwiftUI view
    let contentView = HomeView()

    // Create a UIWindow and set the root view controller to a UIHostingController
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = UIHostingController(rootView: contentView)
    window.makeKeyAndVisible()
    
    return true
  }
}

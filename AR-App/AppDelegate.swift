//
//  AppDelegate.swift
//  AR-App
//
//  Created by Jack Burrows on 27/01/2023.
//

import UIKit
import SwiftUI
import FirebaseCore

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            MenuList()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
    // Set up the SwiftUI view
    let contentView = MenuList()

    // Create a UIWindow and set the root view controller to a UIHostingController
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = UIHostingController(rootView: contentView)
    window.makeKeyAndVisible()

    
    // Implement Firebase
    FirebaseApp.configure()
    
    return true
  }
}

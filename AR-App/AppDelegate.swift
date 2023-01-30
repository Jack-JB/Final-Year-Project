//
//  AppDelegate.swift
//  AR-App
//
//  Created by Jack Burrows on 27/01/2023.
//

import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
    // Create a new instance of ARViewController
    let arViewController = ARViewController()
    
    // Create a new UIWindow with the same frame as the device's screen
    window = UIWindow(frame: UIScreen.main.bounds)
    
    // Set the ARViewController as the root view controller of the window
    window?.rootViewController = arViewController
    
    // Make the window visible
    window?.makeKeyAndVisible()
    
    return true
  }
}

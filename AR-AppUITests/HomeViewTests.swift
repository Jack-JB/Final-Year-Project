//
//  HomeViewTests.swift
//  HomeViewTests
//
//  Created by Jack Burrows on 27/01/2023.
//

import Firebase
import XCTest
import SwiftUI

@testable import AR_App

class HomeViewTests: XCTestCase {
    
    func testNavigationLink() throws {
        
        // ARRANGE:
        let app = XCUIApplication()
        app.launch()
        
        let startButton = app.buttons["Start Solo AR Experience"]
        let backButton = app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Back"]
        
        // ACT / ASSERT:
        XCTAssertTrue(startButton.exists)
        startButton.tap()

        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        
    }
}

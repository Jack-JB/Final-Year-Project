//
//  AR_AppTests.swift
//  AR-AppTests
//
//  Created by Jack Burrows on 27/01/2023.
//

import XCTest
import Firebase
import SceneKit
import XCTest


@testable import AR_App


class JsonManagerTests: XCTestCase {
    
    var jsonManager: JsonManager!
    var fileName: String!
    var fileURL: URL!
    
    
    // Function called first, sets up the test environment
    override func setUp() {
        super.setUp()
        jsonManager = JsonManager()
        fileName = "test.json"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        let testData = [
            ["name": "Jack", "age": 28],
            ["name": "Helena", "age": 28]
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: testData, options: [])
        FileManager.default.createFile(atPath: fileURL.path, contents: jsonData, attributes: nil)
    }
    
    // Function called last to end the test environment and remove any testing files/data created during testing
    override func tearDown() {
        try! FileManager.default.removeItem(at: fileURL)
        super.tearDown()
    }
    
    // Tests that testPrintJSONFileContents does not throw any errors
    func testPrintJSONFileContents() {
        // ARRANGE:
        // Arrange not required, as it is all located within setUp()
        
        // ACT:
        jsonManager.printJSONFileContents(fileName: fileName)
        
        // ASSERT:
        // There is nothing to assert with the output of this function as it only prints to the console,
        // so this test will just test for any errors thrown.
        XCTAssertNoThrow(try jsonManager.printJSONFileContents(fileName: fileName))
    }
    
    func testCheckJSONFileExists() {
        // Arrange
        let fileName = "test.json"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // Create a test JSON file with some sample data
        let testData = [
            ["name": "John", "age": 30],
            ["name": "Jane", "age": 25]
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: testData, options: [])
        FileManager.default.createFile(atPath: fileURL.path, contents: jsonData, attributes: nil)
        
        // Act
        let fileExists = JsonManager().checkJSONFileExists(fileName: fileName)
        
        // Assert
        XCTAssertTrue(fileExists, "The JSON file should exist")
        
        // Clean up the test file
        try! FileManager.default.removeItem(at: fileURL)
    }


}
    








/*
final class AR_AppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
*/

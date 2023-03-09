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
    
    // Tests that testCheckJSONFileExists() and will assert whether the file created exists.
    func testCheckJSONFileExists() {
        // ARRANGE:
        // Arrange not required, as it is all located within setUp()
        
        // ACT:
        let fileExists = JsonManager().checkJSONFileExists(fileName: fileName)
        
        // ASSERT:
        XCTAssertTrue(fileExists, "The JSON file should exist")
    }
    
    // Test that Json data can be parsed into SCNNode data with the function loadNodesFromJSONData()
    func testLoadNodesFromJSONData() {
        
        // ARRANGE:
        let jsonString = """
        {
            "nodes": [
                {
                    "name": "node",
                    "position": { "x": 0.0, "y": 0.0, "z": 0.0 },
                    "scale": { "x": 1.0, "y": 1.0, "z": 1.0 },
                    "rotation": { "x": 0.0, "y": 0.0, "z": 0.0, "w": 1.0 },
                    "color": { "r": 1.0, "g": 0.0, "b": 0.0 }
                }
            ]
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let expectedNodesCount = 1
        let expectedNodeName = "node"
        
        // ACT:
        let result = jsonManager.loadNodesFromJSONData(jsonData: jsonData)
        
        // ASSERT:
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.count, expectedNodesCount)
        XCTAssertEqual(result![0].name, expectedNodeName)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    
    func testSaveNodesAsJSONFile() {
        // ARRANGE
        // Create a test SCNNode
        let testNode = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
        testNode.name = "testNode"
        testNode.position = SCNVector3(1, 2, 3)
        
        // Save the test node to a JSON file
        let fileName = "testFile.json"
        let saved = jsonManager.saveNodesAsJSONFile(nodes: [testNode], fileName: fileName)
        XCTAssertTrue(saved, "Failed to save JSON file")
        
        // Read the contents of the saved JSON file
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            XCTFail("Error getting documents directory")
            return
        }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let jsonString = try? String(contentsOf: fileURL) else {
            XCTFail("Error reading JSON file")
            return
        }
        
        // Convert the JSON string to a dictionary
        guard let jsonDict = try? JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: []) as? [String: Any] else {
            XCTFail("Error parsing JSON string")
            return
        }
        
        // Assert that the dictionary contains the expected node data
        guard let nodesArray = jsonDict["nodes"] as? [[String: Any]], let nodeData = nodesArray.first else {
            XCTFail("Error getting nodes from JSON dictionary")
            return
        }
        XCTAssertEqual(nodeData["name"] as? String, "testNode", "Node name is incorrect")
        guard let positionData = nodeData["position"] as? [String: Any] else {
            XCTFail("Error getting position data from JSON dictionary")
            return
        }
        XCTAssertEqual(positionData["x"] as? Float, 1, "Node x position is incorrect")
        XCTAssertEqual(positionData["y"] as? Float, 2, "Node y position is incorrect")
        XCTAssertEqual(positionData["z"] as? Float, 3, "Node z position is incorrect")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
*/

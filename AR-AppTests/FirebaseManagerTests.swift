//
//  FirebaseManagerTests.swift
//  AR-AppTests
//
//  Created by Jack Burrows on 09/03/2023.
//

import XCTest
import Firebase

@testable import AR_App

final class FirebaseManagerTests: XCTestCase {
    let firebaseManager = FirebaseManager()
    
    override func setUp() {
        FirebaseApp.configure()
    }
    
    func testSendJSONDataToFirestore() {
        // ARRANGE
        let mockData = ["name": "John Doe", "age": 30] as [String : Any]
        let mockCollectionName = "testCollection"
        let mockDocumentName = "testDocument"
        
        let db = Firestore.firestore()
        let docRef = db.collection(mockCollectionName).document(mockDocumentName)
        
        // ACT
        firebaseManager.sendJSONDataToFirestore(data: mockData, collectionName: mockCollectionName, documentName: mockDocumentName)
        
        // ASSERT
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                XCTAssertEqual(data?["name"] as? String, "John Doe")
                XCTAssertEqual(data?["age"] as? Int, 30)
            } else {
                XCTFail("Document not found")
            }
        }
    }
    
    // TEST CURRENTLY NOT WORKING
    func testGetDataFromFirestoreById() {
        // ARRANGE
        let db = Firestore.firestore()
        let collectionName = "testCollection"
        let documentName = "testDocument"
        let data: [String: Any] = ["name": "John Doe", "age": 30]
        let docRef = db.collection(collectionName).document(documentName)
        docRef.setData(data)
        
        // ACT
        var returnedData: [String: Any]?
        var returnedError: Error?
        let expectation = self.expectation(description: "Completion handler called")
        firebaseManager.getDataFromFirestoreById(documentId: documentName, collectionName: collectionName) { (data, error) in
            returnedData = data
            returnedError = error
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // ASSERT
        XCTAssertNil(returnedError)
        XCTAssertEqual(returnedData?["name"] as? String, "John Doe")
        XCTAssertEqual(returnedData?["age"] as? Int, 30)
        
        // Clean up
        docRef.delete()
    }

}

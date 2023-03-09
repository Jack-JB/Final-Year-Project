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
    
    func testSendJSONDataToFirestore_integration() {
        // ARRANGE
        let db = Firestore.firestore()
        let collectionName = "testCollection"
        let documentName = "testDocument"
        
        // ACT
        let data = ["name": "John Doe", "age": 30] as [String : Any]
        firestoreManager.sendJSONDataToFirestore(data: data, collectionName: collectionName, documentName: documentName)
        
        // ASSERT
        let docRef = db.collection(collectionName).document(documentName)
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


}

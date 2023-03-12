//
//  FirebaseManager.swift
//  AR-App
//
//  Created by Jack Burrows on 28/02/2023.
//

import Foundation
import Firebase

class FirebaseManager {
    
    private let db = Firestore.firestore()
    
    func sendJSONDataToFirestore(data: [String: Any], collectionName: String, documentName: String) {
        let docRef = db.collection(collectionName).document(documentName)
        docRef.setData(data) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added with ID: \(docRef.documentID)")
            }
        }
    }

    
    func getDataFromFirestoreById(documentId: String, collectionName: String, completion: @escaping (_ data: [String: Any]?, _ error: Error?) -> Void) {
        let docRef = db.collection(collectionName).document(documentId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document found, parse the data
                if let data = document.data() {
                    completion(data, nil)
                } else {
                    completion(nil, NSError(domain: "getDataFromFirestoreById", code: 1, userInfo: ["message": "Document has no data"]))
                }
            } else {
                // Document not found or error occurred
                completion(nil, error)
            }
        }
    }
    
    func loadData(completion: @escaping (Result<[DocumentSnapshot], Error>) -> Void) {
        let collectionRef = db.collection("myCollection")
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let querySnapshot = querySnapshot {
                    let documents = querySnapshot.documents
                    completion(.success(documents))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No documents found"])
                    completion(.failure(error))
                }
            }
        }
    }
}

//
//  FirebaseManager.swift
//  AR-App
//
//  Created by Jack Burrows on 28/02/2023.
//

import Foundation
import Firebase

class FirebaseManager {
    
    func sendJSONDataToFirestore(data: [String: Any], collectionName: String) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection(collectionName).addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func getDataFromFirestoreById(documentId: String, collectionName: String, completion: @escaping (_ data: [String: Any]?, _ error: Error?) -> Void) {
        let db = Firestore.firestore()
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
}

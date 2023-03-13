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
    
    /// This function sends Json data to Firestore
    ///
    /// - Paramaters:
    ///     - data: The data to upload to Firestore as [String: Any]
    ///     - collectionName: The collection name within Firestore, String
    ///     - documentName: The name of the document to upload, String
    func sendJSONDataToFirestore(data: [String: Any], collectionName: String, documentName: String) {
        // Create a reference to the document to be added
        let docRef = db.collection(collectionName).document(documentName)
        docRef.setData(data) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added with ID: \(docRef.documentID)")
            }
        }
    }

    /// Retrieves a document from a Firestore collection by its ID.
    ///
    /// - Parameters:
    ///     - documentId: The ID of the document to retrieve.
    ///     - collectionName: The name of the collection where the document is located.
    ///     - completion: A closure that is called with the retrieved data or an error.
    ///
    /// The `completion` closure is called asynchronously, and is passed two parameters:
    /// - `data`: A dictionary containing the retrieved data, or `nil` if an error occurred.
    /// - `error`: An error object, or `nil` if the data was retrieved successfully.
    func getDataFromFirestoreById(documentId: String, collectionName: String, completion: @escaping (_ data: [String: Any]?, _ error: Error?) -> Void) {
        let docRef = db.collection(collectionName).document(documentId)
        
        // get the document and its reference
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document was found and has data, parse the data
                if let data = document.data() {
                    completion(data, nil)
                } else {
                    // No data found within the document
                    completion(nil, NSError(domain: "getDataFromFirestoreById", code: 1, userInfo: ["message": "Document has no data"]))
                }
            } else {
                // Document not found or error occurred
                completion(nil, error)
            }
        }
    }
    
    /// Retrieves all documents in the "myCollection" Firestore collection.
    ///
    /// - Parameter completion: The closure to call with the retrieved documents or an error.
    func loadData(completion: @escaping (Result<[DocumentSnapshot], Error>) -> Void) {
        // Reference to the Firestore collection
        let collectionRef = db.collection("myCollection")
        // Fetch all documents within the collection
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let querySnapshot = querySnapshot {
                    // If documents exist, extract them and call the completion closure with a success Result.
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

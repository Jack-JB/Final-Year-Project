//
//  Menu.swift
//  AR-App
//
//  Created by Jack Burrows on 01/03/2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import ARKit

struct DocumentRowView: View {
    let icon: Image
    let documentID: String
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            icon
            Text(documentID.capitalized)
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct MenuView: View {
    // Dictionary that maps strings to values of any type
    @State private var jsonData: [String: Any] = [:]
    // Array of `DocumentSnapshot` objects
    @State private var documents: [DocumentSnapshot] = []
    // Environment value to allow the dismissal of the view
    @Environment(\.dismiss) var dismiss
    
    let firebaseManager = FirebaseManager()
    let arViewController = ARViewController()
    let jsonManager = JsonManager()
    
    var body: some View {
        NavigationView {
            /* Create a `List` that displays the `documents` array
            / `id` is a key path that uniquely identifies each element of the list
            / Each element is represented by a `DocumentRowView` instance
            / When a row is tapped, it loads data for the corresponding document within Firebase
            / and dismisses the current view */
            List(documents, id: \.documentID) { document in
                DocumentRowView(icon: Image(systemName: "scribble.variable"),
                    documentID: document.documentID,
                    onTap: {
                        loadData(documentID: document.documentID)
                        dismiss()
                    })
            }
            // Use the `onAppear` modifier to load data from Firebase when the view appears
            .onAppear {
                firebaseManager.loadData { result in
                    switch result {
                    case .success(let documents):
                        // When the data is loaded successfully, update the `documents` state property
                        self.documents = documents
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            .navigationTitle("Drawings")
        }
    }
    
    private func loadData(documentID: String) {
        let db = Firestore.firestore()
        let collection = db.collection("myCollection")
        let docId = documentID
        
        collection.document(docId).getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    // Successfully loaded the data
                    if jsonManager.saveJSONDataToFile(jsonData: data, fileName: "nodes.json") {
                        print("JSON file saved successfully!")
                        //print(data)
                    } else {
                        print("Error saving JSON file.")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

#if DEBUG
struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
#endif

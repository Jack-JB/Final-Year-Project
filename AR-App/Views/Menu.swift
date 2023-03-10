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
            Text(documentID)
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct MenuView: View {
    @State var jsonData: [String: Any] = [:]
    @State var documents: [DocumentSnapshot] = []
    @Environment(\.dismiss) var dismiss
    let firebaseManager = FirebaseManager()
    let arViewController = ARViewController()
    let jsonManager = JsonManager()
    
    var body: some View {
        NavigationView {
            List(documents, id: \.documentID) { document in
                DocumentRowView(icon: Image(systemName: "scribble.variable"),
                    documentID: document.documentID,
                    onTap: {
                        loadData(documentID: document.documentID)
                        dismiss()
                    })
            }
            .onAppear {
                firebaseManager.loadData { result in
                    switch result {
                    case .success(let documents):
                        self.documents = documents
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            .navigationTitle("Drawings")
        }
    }
    
    func loadData(documentID: String) {
        let db = Firestore.firestore()
        let collection = db.collection("myCollection")
        let docId = documentID
        
        collection.document(docId).getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    // Successfully loaded the data
                    if jsonManager.saveJSONDataToFile(jsonData: data, fileName: "nodes.json") {
                        print("JSON file saved successfully!")
                        print(data)
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

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

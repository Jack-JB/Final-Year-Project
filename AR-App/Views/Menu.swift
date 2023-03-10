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

protocol MenuDelegate: AnyObject {
    func didSelectData(_ data: [String: Any])
}

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
    @Environment(\.dismiss) var dismiss
    weak var delegate: MenuDelegate?
    let firebaseManager = FirebaseManager()
    let arViewController = ARViewController()
    @State var documents: [DocumentSnapshot] = []
    
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
                    JsonManager().saveJSONDataToFile(jsonData: data, fileName: "nodes.json")
                    if JsonManager().checkJSONFileExists(fileName: "nodes.json") {
                        print("File exists")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}


/*
struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

*/

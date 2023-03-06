//
//  Menu.swift
//  AR-App
//
//  Created by Jack Burrows on 01/03/2023.
//

import SwiftUI
import Firebase
import FirebaseCore

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
    
    let firebaseManager = FirebaseManager()
    let arViewController = ARViewController()
    @State var documents: [DocumentSnapshot] = []
    
    var body: some View {
        NavigationView {
            List(documents, id: \.documentID) { document in
                DocumentRowView(icon: Image(systemName: "scribble.variable"),
                                documentID: document.documentID,
                                onTap: {
                                    arViewController.loadData(documentId: document.documentID)
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
}



struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}


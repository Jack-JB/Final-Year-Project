//
//  Menu.swift
//  AR-App
//
//  Created by Jack Burrows on 01/03/2023.
//

import SwiftUI
import Firebase
import FirebaseCore

struct Element: View {

    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "scribble.variable")
                .font(.system(size: 24))
                .foregroundColor(.black)
                .padding(.trailing, 10)
            Text(text)
        }
    }
}

struct MenuView: View {

    var body: some View {
        NavigationView {
            List{
                Element(text: "Drawing 1")
                Element(text: "Drawing 2")
                Element(text: "Drawing 3")
                Element(text: "Drawing 4")
            }
        }.navigationTitle("Drawing List")
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}


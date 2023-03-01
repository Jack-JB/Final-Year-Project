//
//  StartButton.swift
//  AR-App
//
//  Created by Jack Burrows on 01/03/2023.
//

import SwiftUI

struct StartButton: View {

    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "arkit")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding(.trailing, 10)
            
            Text(text)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

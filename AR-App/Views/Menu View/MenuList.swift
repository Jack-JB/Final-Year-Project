//
//  MenuList.swift
//  AR-App
//
//  Created by Jack Burrows on 01/03/2023.
//

import SwiftUI

struct MenuList: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the AR App!")
                    .font(.title)
                    .padding()
                NavigationLink(destination: ARView()) {
                    VStack{
                        StartButton(text: "Start Solo AR Experience")
                            .padding(10)
                        StartButton(text: "Start Group AR Experience")
                    }
                }
            }
        }
    }
}

struct ARView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ARViewController {
        let arViewController = ARViewController()
        return arViewController
    }

    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        MenuList()
    }
}
#endif

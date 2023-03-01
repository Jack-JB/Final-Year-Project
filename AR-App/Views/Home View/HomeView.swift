//
//  MenuList.swift
//  AR-App
//
//  Created by Jack Burrows on 01/03/2023.
//

import SwiftUI

struct HomeView: View {
    
    let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the AR App!")
                    .font(.title)
                    .frame(maxHeight: .infinity)
                VStack {
                    NavigationLink(destination: ARView()) {
                        StartButton(text: "Start Solo AR Experience")
                    }
                    StartButton(text: "Start group AR Experience")
                    
                    Text("App Build Version: \(buildNumber!)")
                        .frame(maxHeight: .infinity, alignment: .bottomTrailing)
                        .font(.system(size:15))
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
        HomeView()
    }
}
#endif

//
//  MenuViewController.swift
//  AR-App
//
//  Created by Jack Burrows on 21/02/2023.
//

import Foundation
import SwiftUI

class MenuViewController: UIViewController {
    override func viewDidLoad() {
            super.viewDidLoad()

            // Set the title of the navigation bar
            title = "Menu Screen"

            // Create a label and add it to the view
            let myLabel = UILabel()
            myLabel.text = "Hello, world!"
            myLabel.font = UIFont.systemFont(ofSize: 24)
            view.addSubview(myLabel)

            // Position the label using Auto Layout constraints
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                myLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                myLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
}

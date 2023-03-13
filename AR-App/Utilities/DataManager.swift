//
//  DataManager.swift
//  AR-App
//
//  Created by Jack Burrows on 09/03/2023.
//

import Foundation
import SceneKit

// First iteration of saving functionality. This class is no longer in use
class DataManager {
    var nodes = [SCNNode()]
    
    private func save() {
        // Get the URL to the documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // Set the file name for the saved scene
        let fileName = "Scene.arobject"
        // Create the URL for the saved scene file
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // Create an NSKeyedArchiver object to encode the nodes array
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        // Encode the nodes array
        archiver.encode(nodes, forKey: "nodes")
        // Write the encoded data to the file
        let data = archiver.encodedData
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error saving scene: \(error)")
        }
    }

    private func load() -> [SCNNode] {
            // Get the URL to the documents directory
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // Set the file name for the saved scene
            let fileName = "Scene.arobject"
            // Create the URL for the saved scene file
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            // Initialize an NSKeyedUnarchiver object to decode the data from the file
            do {
                let data = try Data(contentsOf: fileURL)
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                // Decode the nodes array from the file
                let decodedNodes = unarchiver.decodeObject(forKey: "nodes") as? [SCNNode]
                // Check if the decoded nodes array is not nil
                if let decodedNodes = decodedNodes {
                    // Return the decoded nodes array
                    return decodedNodes
                } else {
                    print("Error loading scene")
                }
            } catch {
                print("Error reading data from file")
            }
            return []
        }
}

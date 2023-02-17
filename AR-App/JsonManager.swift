//
//  JsonManager.swift
//  AR-App
//
//  Created by Jack Burrows on 15/02/2023.
//

import Foundation
import SceneKit


class JsonManager {
    private let fileManager = FileManager.default
    
    init() {}
    
    func nodesToJSON(nodes: [SCNNode]) -> String? {
        var jsonArray: [[String: Any]] = []
        for node in nodes {
            var jsonDict: [String: Any] = [:]
            jsonDict["name"] = node.name ?? ""
            jsonDict["position"] = [
                "x": node.position.x,
                "y": node.position.y,
                "z": node.position.z
            ]
            jsonDict["scale"] = [
                "x": node.scale.x,
                "y": node.scale.y,
                "z": node.scale.z
            ]
            jsonDict["rotation"] = [
                "x": node.rotation.x,
                "y": node.rotation.y,
                "z": node.rotation.z,
                "w": node.rotation.w
            ]
            if let material = node.geometry?.firstMaterial {
                let color = SCNVector3ToGLKVector3(material.diffuse.contents as! SCNVector3)
                jsonDict["color"] = [
                    "r": color.x,
                    "g": color.y,
                    "b": color.z
                ]
            }
            jsonArray.append(jsonDict)
        }
        let rootDict = ["nodes": jsonArray]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: rootDict, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Error converting nodes to JSON: \(error.localizedDescription)")
            return nil
        }
    }

    func saveNodesAsJSONFile(nodes: [SCNNode], fileName: String) -> Bool {
        guard let jsonString = nodesToJSON(nodes: nodes) else {
            print("Error generating JSON data")
            return false
        }

        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error getting documents directory")
            return false
        }

        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        do {
            try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("JSON file saved to: \(fileURL.path)")
            return true
        } catch {
            print("Error saving JSON file: \(error.localizedDescription)")
            return false
        }
    }
    
    func printJSONFileContents(fileName: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error getting documents directory")
            return
        }

        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        do {
            let jsonData = try Data(contentsOf: fileURL)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let jsonDict = jsonObject as? [String: Any] {
                print(jsonDict)
            } else if let jsonArray = jsonObject as? [[String: Any]] {
                print(jsonArray)
            } else {
                print("Error parsing JSON file: unexpected root object")
            }
        } catch {
            print("Error reading JSON file: \(error.localizedDescription)")
        }
    }

}

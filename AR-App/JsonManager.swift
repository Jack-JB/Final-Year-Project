//
//  JsonManager.swift
//  AR-App
//
//  Created by Jack Burrows on 15/02/2023.
//

import Foundation
import SceneKit


class JsonManager {
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
            jsonArray.append(jsonDict)
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
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

        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
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
    
    
    
    func loadNodes(fromJSONFile filename: String) -> [SCNNode] {
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to locate JSON file")
        }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            guard let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                let nodeData = jsonDict["nodes"] as? [[String: Any]] else {
                    fatalError("Failed to parse JSON file")
            }
            
            var nodes: [SCNNode] = []
            for nodeDatum in nodeData {
                if let position = nodeDatum["position"] as? [Float],
                    let color = nodeDatum["color"] as? [Float] {
                    let node = SCNNode()
                    node.position = SCNVector3(x: Float(position[0]), y: Float(position[1]), z: Float(position[2]))
                    node.geometry = SCNSphere(radius: 0.1)
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor(red: CGFloat(color[0]), green: CGFloat(color[1]), blue: CGFloat(color[2]), alpha: 1.0)
                    nodes.append(node)
                }
            }
            
            return nodes
        } catch {
            fatalError("Failed to load JSON file: \(error)")
        }
    }
}

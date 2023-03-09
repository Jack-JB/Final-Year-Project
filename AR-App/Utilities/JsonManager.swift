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
                if let colorContents = material.diffuse.contents as? SCNVector3 {
                    let color = SCNVector3ToGLKVector3(colorContents)
                    jsonDict["color"] = [
                        "r": color.x,
                        "g": color.y,
                        "b": color.z
                    ]
                }
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
    
    func printJSONData(jsonData: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let jsonDict = jsonObject as? [String: Any] {
                print(jsonDict)
            } else if let jsonArray = jsonObject as? [[String: Any]] {
                print(jsonArray)
            } else {
                print("Error parsing JSON data: unexpected root object")
            }
        } catch {
            print("Error reading JSON data: \(error.localizedDescription)")
        }
    }

    
    func loadNodesFromJSONFile(fileName: String) -> [SCNNode]? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error getting documents directory")
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            guard let nodesArray = jsonObject?["nodes"] as? [[String: Any]] else {
                print("Error parsing JSON data: 'nodes' key not found or value is not an array")
                return nil
            }
            
            var sceneNodes: [SCNNode] = []
            
            for nodeData in nodesArray {
                let node = SCNNode()
                node.name = nodeData["name"] as? String ?? "node"
                if let positionData = nodeData["position"] as? [String: Any],
                   let x = positionData["x"] as? Float,
                   let y = positionData["y"] as? Float,
                   let z = positionData["z"] as? Float {
                    node.position = SCNVector3(x, y, z)
                }
                if let scaleData = nodeData["scale"] as? [String: Any],
                   let x = scaleData["x"] as? Float,
                   let y = scaleData["y"] as? Float,
                   let z = scaleData["z"] as? Float {
                    node.scale = SCNVector3(x, y, z)
                }
                if let rotationData = nodeData["rotation"] as? [String: Any],
                   let x = rotationData["x"] as? Float,
                   let y = rotationData["y"] as? Float,
                   let z = rotationData["z"] as? Float,
                   let w = rotationData["w"] as? Float {
                    node.orientation = SCNQuaternion(x, y, z, w)
                }
                if let colorData = nodeData["color"] as? [String: Any],
                   let r = colorData["r"] as? CGFloat,
                   let g = colorData["g"] as? CGFloat,
                   let b = colorData["b"] as? CGFloat {
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor(red: r, green: g, blue: b, alpha: 1.0)
                }
                sceneNodes.append(node)
            }
            
            // Check if there are any nodes
            guard sceneNodes.count > 0 else {
                print("Error parsing JSON data: no nodes found")
                return nil
            }
            
            // If the root node is not named "node", rename it to "node"
            let rootNode = sceneNodes[0]
            if rootNode.name != "node" {
                rootNode.name = "node"
            }
            
            return sceneNodes
        } catch {
            print("Error loading JSON file: \(error.localizedDescription)")
            return nil
        }
    }
    
    func loadNodesFromJSONData(jsonData: Data) -> [SCNNode]? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            guard let nodesArray = jsonObject?["nodes"] as? [[String: Any]] else {
                print("Error parsing JSON data: 'nodes' key not found or value is not an array")
                return nil
            }
            
            var sceneNodes: [SCNNode] = []
            
            for nodeData in nodesArray {
                let node = SCNNode()
                node.name = nodeData["name"] as? String ?? "node"
                if let positionData = nodeData["position"] as? [String: Any],
                   let x = positionData["x"] as? Float,
                   let y = positionData["y"] as? Float,
                   let z = positionData["z"] as? Float {
                    node.position = SCNVector3(x, y, z)
                }
                if let scaleData = nodeData["scale"] as? [String: Any],
                   let x = scaleData["x"] as? Float,
                   let y = scaleData["y"] as? Float,
                   let z = scaleData["z"] as? Float {
                    node.scale = SCNVector3(x, y, z)
                }
                if let rotationData = nodeData["rotation"] as? [String: Any],
                   let x = rotationData["x"] as? Float,
                   let y = rotationData["y"] as? Float,
                   let z = rotationData["z"] as? Float,
                   let w = rotationData["w"] as? Float {
                    node.orientation = SCNQuaternion(x, y, z, w)
                }
                if let colorData = nodeData["color"] as? [String: Any],
                   let r = colorData["r"] as? CGFloat,
                   let g = colorData["g"] as? CGFloat,
                   let b = colorData["b"] as? CGFloat {
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor(red: r, green: g, blue: b, alpha: 1.0)
                }
                sceneNodes.append(node)
            }
            
            // Check if there are any nodes
            guard sceneNodes.count > 0 else {
                print("Error parsing JSON data: no nodes found")
                return nil
            }
            
            // If the root node is not named "node", rename it to "node"
            let rootNode = sceneNodes[0]
            if rootNode.name != "node" {
                rootNode.name = "node"
            }
            
            return sceneNodes
        } catch {
            print("Error loading JSON data: \(error.localizedDescription)")
            return nil
        }
    }

    func deleteJSONFile(fileName: String) {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = documentsURL.appendingPathComponent(fileName)
        do {
            try fileManager.removeItem(at: fileURL)
        } catch let error {
            print("Error deleting JSON file: \(error.localizedDescription)")
        }
    }
}

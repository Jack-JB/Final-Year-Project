//
//  ContentView.swift
//  AR-App
//
//  Created by Jack Burrows on 27/01/2023.
//

import SwiftUI
import RealityKit
import UIKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
  
    // MARK: - Class Properties
  
    @IBOutlet var sceneView: ARSCNView!
    var currentNode: SCNNode?
    var previousNode: SCNNode?
    var firstNode: SCNNode?
    var nodes: [SCNNode] = []
    var rootNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the ARSCNView
        sceneView = ARSCNView(frame: view.bounds)
        sceneView.delegate = self
        view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Configure the session
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        // Make the view controller the first responder
        becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Enable plane detection
        configuration.planeDetection = [.horizontal]
        
        // MARK: - UI component declaration
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.frame = CGRect(x: 20, y: 800, width: 100, height: 44)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        saveButton.backgroundColor = .darkGray
        view.addSubview(saveButton)
        
        let loadButton = UIButton(type: .system)
        loadButton.setTitle("Load", for: .normal)
        loadButton.frame = CGRect(x: 310, y: 800, width: 100, height: 44)
        loadButton.addTarget(self, action: #selector(loadButtonPressed), for: .touchUpInside)
        loadButton.backgroundColor = .darkGray
        view.addSubview(loadButton)
        
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.frame = CGRect(x: 160, y: 800, width: 100, height: 44)
        clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        clearButton.backgroundColor = .darkGray
        view.addSubview(clearButton)

        // Run the view's session
        sceneView.session.run(configuration)
    }

    // MARK: - Touch even management
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let horizontalRaycastQuery = sceneView.raycastQuery(from: touch.location(in: sceneView), allowing: .estimatedPlane, alignment: .horizontal)!
        let horizontalResults = sceneView.session.raycast(horizontalRaycastQuery)
        
        let verticalRaycastQuery = sceneView.raycastQuery(from: touch.location(in: sceneView), allowing: .estimatedPlane, alignment: .vertical)!
        let verticalResults = sceneView.session.raycast(verticalRaycastQuery)
        
        var hitResult: ARRaycastResult
        
        if let horizontalHitResult = horizontalResults.first {
            hitResult = horizontalHitResult
        } else if let verticalHitResult = verticalResults.first {
            hitResult = verticalHitResult
        } else {
            return
        }
        
        let position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        currentNode = SCNNode()
        currentNode?.geometry = SCNSphere(radius: 0.01)
        currentNode?.position = position
        sceneView.scene.rootNode.addChildNode(currentNode!)
    }
    
    // TODO: First and last node are not part of the array, this needs fixing as they will not be destroyed
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        // Create a raycast query from the touch location, allowing estimated planes and aligning with horizontal planes
        let horizontalRaycastQuery = sceneView.raycastQuery(from: touch.location(in: sceneView), allowing: .estimatedPlane, alignment: .horizontal)!
        let horizontalResults = sceneView.session.raycast(horizontalRaycastQuery)
          
        // Create a raycast query from the touch location, allowing estimated planes and aligning with horizontal planes
        let verticalRaycastQuery = sceneView.raycastQuery(from: touch.location(in: sceneView), allowing: .estimatedPlane, alignment: .vertical)!
        let verticalResults = sceneView.session.raycast(verticalRaycastQuery)
          	
        var hitResult: ARRaycastResult
          
        if let horizontalHitResult = horizontalResults.first {
            hitResult = horizontalHitResult
        } else if let verticalHitResult = verticalResults.first {
            hitResult = verticalHitResult
        } else {
            return
        }
        // Extract the 3D position of the hit result
        let position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
          
        // Create a new sphere node at the touch position
        createSphereNode(at: position, nodes: &nodes, previousNode: &previousNode)
    }

    // MARK: - Node Handler
    // This function creates the sphere nodes to allow the drawing within the app
    func createSphereNode(at position: SCNVector3, nodes: inout [SCNNode], previousNode: inout SCNNode?) {
        let color = UIColor.red
        changeNodeColour(nodes, color: color)
        
        // Create a new sphere node at the touch position
        let sphereNode = SCNNode()
        
        sphereNode.geometry = SCNSphere(radius: 0.01)
        sphereNode.position = position
        
        // Add the sphere node to the scene
        sceneView.scene.rootNode.addChildNode(sphereNode)
        
        // If this is not the first point in the drawing, connect the current point with the previous point using a line
        if previousNode != nil {
            sceneView.scene.rootNode.addChildNode(sphereNode)
        }
        // Update the previous node to be the current sphere node for the next point
        nodes.append(sphereNode)
        rootNode = sphereNode
        previousNode = sphereNode
    }

    // TODO: Create a UI button to handle this function
    func changeNodeColour(_ nodes: [SCNNode], color: UIColor) {
        for node in nodes {
            if let geometry = node.geometry {
                let material = geometry.firstMaterial!
                material.diffuse.contents = color
            }
        }
    }

    // MARK: - Save, Load functionality
    func save() {
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

    func load() -> [SCNNode] {
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
                    for node in decodedNodes {
                            print(node)
                        }
                    return decodedNodes
                } else {
                    print("Error loading scene")
                }
            } catch {
                print("Error reading data from file")
            }
            return []
        }

        @IBAction func loadButtonPressed(_ sender: UIButton) {
            let fileName = "Nodes.json"
            let jsonManager = JsonManager()

            if let newNodes = jsonManager.loadNodesFromJSONFile(fileName: fileName) {
                for node in newNodes {
                    //self.nodes.append(node)
                    sceneView.scene.rootNode.addChildNode(node)
                }
                // Debugging statements
                print(self.nodes)
                print("==============================")
                print(newNodes)
                let areEqual = areArraysEqual(newNodes, self.nodes)
                print("==============================")
                print("Equal arrays: \(areEqual)")
                print("newNodes type is: \(getType(newNodes))")
            } else {
                // newNodes is nil, which means the JSON file could not be loaded
                print("Error loading nodes from JSON file")
            }
        }
    
    // Debugging purposes: Check if 2 arrays are equal
    func areArraysEqual(_ array1: [SCNNode], _ array2: [SCNNode]) -> Bool {
        return array1 == array2
    }
    
    // Debugging purposes: Return the type of an array
    func getType<T>(_ array: [T]) -> String {
        return "\(type(of: array))"
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        //save()
        
    }

    @IBAction func clearButtonPressed(_ sender: Any) {
        //clear()
            
    }
    
    func removeNode(_ node: SCNNode) {
        node.removeFromParentNode()
        nodes = nodes.filter { $0 !== node }
    }

    func clear() {
        for node in nodes {
            removeNode(node)
        }
    }
}

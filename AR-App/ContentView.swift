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
  var nodes: [SCNNode] = []

  // MARK: - UI component functionality
  
  @objc func saveButtonAction() {
  // TODO: - Save button functionality
  }
  
  @objc func loadButtonAction() {
      // TODO: - Load button functionality
  }
    
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
      clearButton.frame = CGRect(x: 215, y: 800, width: 100, height: 44)
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
    let color = UIColor.red
      changeNodeColour(nodes, color: color)

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
    previousNode = sphereNode
  }
    
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    currentNode = nil
  }

  // MARK: - createLine function
    
  // This handles the functionality of creating lines from a series of sphere nodes
    func createLine(from node1: SCNNode, to node2: SCNNode) -> [SCNNode] {
        // Initialize an empty array to store the sphere nodes
        var sphereNodes: [SCNNode] = []
        // Calculate the distance between the two nodes
        let distance = sqrt(
          pow(node1.position.x - node2.position.x, 2) +
          pow(node1.position.y - node2.position.y, 2) +
          pow(node1.position.z - node2.position.z, 2)
        )
        // Determine the number of spheres to create based on the distance
        let numSpheres = Int(distance / 0.01)
        // Calculate the distance between each sphere
        let sphereDistance = distance / Float(numSpheres)
        // Create a vector to represent the direction of the line
        let lineVector = SCNVector3(node2.position.x - node1.position.x, node2.position.y - node1.position.y, node2.position.z - node1.position.z)
        // Iterate through the number of spheres to create
        for i in 0..<numSpheres {
          // Create a sphere node
          let sphereNode = SCNNode()
          // Set the sphere's geometry to a sphere with a radius of 0.005
          sphereNode.geometry = SCNSphere(radius: 0.005)
          // Calculate the position of the sphere based on the line vector and distance between spheres
          let position = SCNVector3(node1.position.x + lineVector.x * (sphereDistance * Float(i)), node1.position.y + lineVector.y * (sphereDistance * Float(i)), node1.position.z + lineVector.z * (sphereDistance * Float(i)))
          // Set the sphere node's position to the calculated position
          sphereNode.position = position
          // Append the sphere node to the array of sphere nodes
          sphereNodes.append(sphereNode)
          nodes.append(sphereNode)
          }
            // Return the array of sphere nodes
            return sphereNodes
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

    @IBAction func loadButtonPressed(_ sender: Any) {
            nodes = load()
            for node in nodes {
                sceneView.scene.rootNode.addChildNode(node)
            }
        }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        save()
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        clear()
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

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
    
    var sceneView: ARSCNView!
    var currentNode: SCNNode?
    var previousNode: SCNNode?
    
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

        // Run the view's session
        sceneView.session.run(configuration)
    }

    // MARK: - Touch even management
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get the first touch event from the set of touch events
        guard let touch = touches.first else { return }

        // Create a raycast query starting from the touch location in the sceneView
        let raycastQuery = sceneView.raycastQuery(from: touch.location(in: sceneView), allowing: .estimatedPlane, alignment: .horizontal)!

        // Perform the raycast query
        let results = sceneView.session.raycast(raycastQuery)

        // Get the first result of the raycast query
        guard let hitResult = results.first else { return }

        // Get the position of the hit result
        let position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)

        // Create a new node with a sphere geometry
        currentNode = SCNNode()
        currentNode?.geometry = SCNSphere(radius: 0.01)

        // Position the node at the hit result position
        currentNode?.position = position

        // Add the node to the scene's root node
        sceneView.scene.rootNode.addChildNode(currentNode!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        // Create a raycast query from the touch location, allowing estimated planes and aligning with horizontal planes
        let raycastQuery = sceneView.raycastQuery(from: touch.location(in: sceneView), allowing: .estimatedPlane, alignment: .horizontal)!
        // Perform the raycast query and get the results
        let results = sceneView.session.raycast(raycastQuery)
        guard let hitResult = results.first else { return }
        // Extract the 3D position of the hit result
        let position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        // Create a new sphere node at the touch position
        let sphereNode = SCNNode()
        sphereNode.geometry = SCNSphere(radius: 0.01)
        sphereNode.position = position
        // Add the sphere node to the scene
        sceneView.scene.rootNode.addChildNode(sphereNode)
        // If this is not the first point in the drawing, connect the current point with the previous point using a line
        if let previousNode = previousNode {
            let lineNode = createLine(from: previousNode, to: sphereNode)
            sceneView.scene.rootNode.addChildNode(sphereNode)
        }
        // Update the previous node to be the current sphere node for the next point
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
        }
        // Return the array of sphere nodes
        return sphereNodes
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}

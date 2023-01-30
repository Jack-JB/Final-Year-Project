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
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        saveButton.backgroundColor = .darkGray
        view.addSubview(saveButton)
        
        let loadButton = UIButton(type: .system)
        loadButton.setTitle("Load", for: .normal)
        loadButton.frame = CGRect(x: 310, y: 800, width: 100, height: 44)
        loadButton.addTarget(self, action: #selector(loadButtonAction), for: .touchUpInside)
        loadButton.backgroundColor = .darkGray
        view.addSubview(loadButton)

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
        if previousNode != nil {
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
    
    // This function will save drawing data as a json object
    // NOTE: This is untested as of now.
    func saveLine(line: [SCNNode]) {
        var sphereData = [SphereData]()
        for sphere in line {
            let data = SphereData(position: sphere.position, radius: sphere.geometry?.boundingSphere.radius ?? 0)
            sphereData.append(data)
        }
        let jsonEncoder = JSONEncoder()
        if let jsonData = try? jsonEncoder.encode(sphereData) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                // TODO: Add functionality
            }
        }
    }
    
    // This struct will hold the positional data of the spheres ready to store as a json object
    struct SphereData: Encodable {
        let position: SCNVector3
        let radius: Float
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(position.x, forKey: .x)
            try container.encode(position.y, forKey: .y)
            try container.encode(position.z, forKey: .z)
            try container.encode(radius, forKey: .radius)
        }
        
        private enum CodingKeys: String, CodingKey {
            case x, y, z, radius
        }
    }
}

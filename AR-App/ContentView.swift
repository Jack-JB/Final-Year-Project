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
    
    var sceneView: ARSCNView!
    var currentNode: SCNNode?
    
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
    // check if a touch event exists
    guard let touch = touches.first else { return }

        // create a raycast query using the touch's location in the sceneView and set the allowed alignment to horizontal
        let raycastQuery = sceneView.raycastQuery(from: touch.location(in: sceneView), allowing: .estimatedPlane, alignment: .horizontal)!
        
        // perform the raycast query using the current AR session and retrieve the results
        let results = sceneView.session.raycast(raycastQuery)
        
        // check if there is a hit result
        guard let hitResult = results.first else { return }
        
        // extract the position from the hitResult's worldTransform matrix
        let position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        // update the position of the currentNode to the new position
        currentNode?.position = position
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentNode = nil
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}

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
import SceneKit

protocol JSONDataDelegate: AnyObject {
    func didReceiveJSONData(_ data: [String: Any])
}

class ARViewController: UIViewController, ARSCNViewDelegate {

    // MARK: - Class Properties
  
    @IBOutlet var sceneView: ARSCNView!
    private var currentNode: SCNNode?
    private var previousNode: SCNNode?
    private var firstNode: SCNNode?
    private var nodes: [SCNNode] = []
    private var rootNode = SCNNode()
    
    // MARK: - View Management
    override internal func viewDidLoad() {
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
        
        let expandableButton = ExpandableButton(frame: CGRect(x: 50, y: 700, width: 150, height: 50))
                expandableButton.setTitle("Change Colour", for: .normal)
                expandableButton.backgroundColor = .gray
                
                view.addSubview(expandableButton)
    }
    
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Enable plane detection
        configuration.planeDetection = [.horizontal]
        
        // MARK: - UI component declaration
        
        let expandableButton = ExpandableButton(frame: CGRect(x: 310, y: 100, width: 150, height: 50))
        view.addSubview(expandableButton)

        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.frame = CGRect(x: 20, y: 750, width: 100, height: 44)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        saveButton.backgroundColor = .darkGray
        view.addSubview(saveButton)
        
        let loadButton = UIButton(type: .system)
        loadButton.setTitle("Load", for: .normal)
        loadButton.frame = CGRect(x: 310, y: 750, width: 100, height: 44)
        loadButton.addTarget(self, action: #selector(loadButtonPressed), for: .touchUpInside)
        loadButton.backgroundColor = .darkGray
        view.addSubview(loadButton)
        
       let clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.frame = CGRect(x: 160, y: 750, width: 100, height: 44)
        clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        clearButton.backgroundColor = .darkGray
        view.addSubview(clearButton)
        
        let testButton = UIButton(type: .system)
        testButton.setTitle("Load", for: .normal)
        testButton.frame = CGRect(x: 160, y: 650, width: 100, height: 44)
        testButton.addTarget(self, action: #selector(testButtonPressed), for: .touchUpInside)
        testButton.backgroundColor = .darkGray
        view.addSubview(testButton)

        // Run the view's session
        sceneView.session.run(configuration)
    }

    // MARK: - Touch event management
    override internal func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    override internal func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        // Create a raycast query from the touch location, allowing estimated planes and aligning with horizontal planes
        let horizontalRaycastQuery = sceneView.raycastQuery(from: touch.location(in: sceneView), allowing: .estimatedPlane, alignment: .horizontal)!
        let horizontalResults = sceneView.session.raycast(horizontalRaycastQuery)
        
        // Create a raycast query from the touch location, allowing estimated planes and aligning with vertical planes
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
        createSphereNode(at: position, nodes: &nodes, previousNode: &previousNode, rootNode: sceneView.scene.rootNode)
    }

    // MARK: - Node Handler
    // This function creates the sphere nodes to allow the drawing within the app
    private func createSphereNode(at position: SCNVector3, nodes: inout [SCNNode], previousNode: inout SCNNode?, rootNode: SCNNode) {
            
        // Create a new sphere node at the touch position
        let sphereNode = SCNNode()
            
        sphereNode.geometry = SCNSphere(radius: 0.01)
        sphereNode.position = position
            
        // Add the sphere node to the parent node
        rootNode.addChildNode(sphereNode)
            
        // Update the previous node to be the current sphere node for the next point
        nodes.append(sphereNode)
        previousNode = sphereNode
    }

    // TODO: Create a UI button to handle this function
    private func changeNodeColour(_ nodes: [SCNNode], color: UIColor) {
        for node in nodes {
            if let geometry = node.geometry {
                let material = geometry.firstMaterial!
                material.diffuse.contents = color
            }
        }
    }
    
    // MARK: - IBAction functons
    @IBAction private func testButtonPressed(_ sender: UIButton){
        let jsonManager = JsonManager()
        
        nodes = jsonManager.loadNodesFromJSONFile(fileName: "nodes.json")!
        for node in nodes {
            node.geometry = SCNSphere(radius: 0.01)
            sceneView.scene.rootNode.addChildNode(node)
        }
        
    
    }
    
    @IBAction private func loadButtonPressed(_ sender: UIButton) {
       

    }
    
    @IBAction private func saveButtonPressed(_ sender: Any) {
        let jsonManager = JsonManager()
        jsonManager.saveNodesAsJSONFile(nodes: nodes, fileName: "Nodes.json")
        
        let firebaseManager = FirebaseManager()
        
        // Create an alert controller with a text field for entering the document name
        let alertController = UIAlertController(title: "Save Drawing", message: "Enter a name for your drawing:", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Drawing Name"
        }
        
        // Add save and cancel actions to the alert controller
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            // Get the text entered in the text field and use it as the document name
            guard let drawingName = alertController.textFields?.first?.text, !drawingName.isEmpty else {
                // Show an error message if no name was entered
                self.showErrorMessage(message: "Please enter a name for your drawing.")
                return
            }
            
            let collectionName = "myCollection"
            
            let jsonString = JsonManager().nodesToJSON(nodes: self.nodes)
            let jsonData = jsonString!.data(using: .utf8)!
            let serialisedJson = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            
            // Send the JSON data to Firestore using the drawing name as the document ID
            firebaseManager.sendJSONDataToFirestore(data: serialisedJson, collectionName: collectionName, documentName: drawingName)
        }
        alertController.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction private func showMenuButtonPressed(_ sender: UIButton) {
            let myMenuView = MenuView()
            let hostingController = UIHostingController(rootView: myMenuView)
            present(hostingController, animated: true, completion: nil)
        }
    
    @IBAction private func clearButtonPressed(_ sender: Any) {
        clear()
    }
    
    // MARK: - Main class functions
    
    public func loadData(documentId: String, completion: @escaping (Data?, Error?) -> Void) {
        let firebaseManager = FirebaseManager()

        firebaseManager.getDataFromFirestoreById(documentId: documentId, collectionName: "myCollection") { data, error in
            if let data = data {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    completion(jsonData, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }

    private func showErrorMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    private func removeNode(_ node: SCNNode) {
        node.removeFromParentNode()
        nodes = nodes.filter { $0 !== node }
    }

    private func clear() {
        for node in nodes {
            removeNode(node)
        }
        
        rootNode.removeAllActions()
        rootNode.removeAllAnimations()
        rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
}

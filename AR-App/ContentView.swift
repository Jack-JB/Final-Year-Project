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
        
        let expandableButton = ExpandableButton(frame: CGRect(x: 50, y: 700, width: 150, height: 50))
                expandableButton.setTitle("Change Colour", for: .normal)
                expandableButton.backgroundColor = .gray
                
                view.addSubview(expandableButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        clearButton.addTarget(self, action: #selector(showMenuButtonPressed), for: .touchUpInside)
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
    func createSphereNode(at position: SCNVector3, nodes: inout [SCNNode], previousNode: inout SCNNode?, rootNode: SCNNode) {
            
        // Create a new sphere node at the touch position
        let sphereNode = SCNNode()
            
        sphereNode.geometry = SCNSphere(radius: 0.01)
        sphereNode.position = position
            
        // Add the sphere node to the parent node
        rootNode.addChildNode(sphereNode)
            
        // If this is not the first point in the drawing, connect the current point with the previous point using a line
       
            
        // Update the previous node to be the current sphere node for the next point
        nodes.append(sphereNode)
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
            let firebaseManager = FirebaseManager()
           
            // current parameter used as placeholder for testing
            loadData(documentId: "tree")
            print(nodes)
           /* nodes = jsonManager.loadNodesFromJSONFile(fileName: fileName)!
            for node in nodes {
                node.geometry = SCNSphere(radius: 0.01)
                sceneView.scene.rootNode.addChildNode(node)
            } */
        }
    
    func loadData(documentId: String) {
        let firebaseManager = FirebaseManager()
        let jsonManager = JsonManager()
        
        firebaseManager.getDataFromFirestoreById(documentId: documentId, collectionName: "myCollection") { [self] data, error in
             if let data = data {
                 // Process the data here
                 do {
                     let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                     nodes = jsonManager.loadNodesFromJSONData(jsonData: jsonData)!
                     
                     for node in nodes {
                         node.geometry = SCNSphere(radius: 0.01)
                         sceneView.scene.rootNode.addChildNode(node)
                     }
                     // Use the jsonData here
                 } catch {
                     // Handle the error here
                     print(error.localizedDescription)
                 }
                 
                 //print(data)
             } else {
                 // Handle the error
                 print(error?.localizedDescription ?? "Unknown error")
             }
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

    func showErrorMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }


    @IBAction func clearButtonPressed(_ sender: Any) {
        clear()
            
    }
    
    @objc func didTapFirstButton() {
        changeNodeColour(nodes, color: UIColor.blue)
        }
    
    func removeNode(_ node: SCNNode) {
        node.removeFromParentNode()
        nodes = nodes.filter { $0 !== node }
    }

    func clear() {
        for node in nodes {
            removeNode(node)
        }
        
        rootNode.removeAllActions()
        rootNode.removeAllAnimations()
        rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
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
    
    @IBAction func showMenuButtonPressed(_ sender: UIButton) {
            let myMenuView = MenuView()
            let hostingController = UIHostingController(rootView: myMenuView)
            present(hostingController, animated: true, completion: nil)
        }
}

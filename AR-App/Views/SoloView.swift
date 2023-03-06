//
//  ContentView.swift
//  AR-App
//
//  Created by Jack Burrows on 27/01/2023.
//
/*
import SwiftUI
import RealityKit
import UIKit
import ARKit

struct ARViewWrapper: UIViewRepresentable {
    let arView = ARSCNView()
    var nodes: [SCNNode] = []
    
    func makeUIView(context: Context) -> ARSCNView {
        arView.delegate = context.coordinator
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(ARView())
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARView
        
        init(_ parent: ARView) {
            self.parent = parent
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                let planeNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
                planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
                planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
                planeNode.eulerAngles.x = -.pi / 2
                node.addChildNode(planeNode)
            }
        }
        
         func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            
            let horizontalRaycastQuery = parent.arView.raycastQuery(from: touch.location(in: parent.arView), allowing: .estimatedPlane, alignment: .horizontal)!
            let horizontalResults = parent.arView.session.raycast(horizontalRaycastQuery)
            
            let verticalRaycastQuery = parent.arView.raycastQuery(from: touch.location(in: parent.arView), allowing: .estimatedPlane, alignment: .vertical)!
            let verticalResults = parent.arView.session.raycast(verticalRaycastQuery)
            
            var hitResult: ARRaycastResult
            
            if let horizontalHitResult = horizontalResults.first {
                hitResult = horizontalHitResult
            } else if let verticalHitResult = verticalResults.first {
                hitResult = verticalHitResult
            } else {
                return
            }
            
            let position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
            
            let currentNode = SCNNode()
             currentNode.geometry = SCNSphere(radius: 1.0)
            currentNode.position = position
            parent.arView.scene.rootNode.addChildNode(currentNode)
        }
        
        func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            guard let arView = touch.view as? ARView else { return }
            
            // Create a raycast query from the touch location, allowing estimated planes and aligning with horizontal planes
            let horizontalRaycastQuery = arView.arView.raycastQuery(from: touch.location(in: arView.arView), allowing: .estimatedPlane, alignment: .horizontal)!
            let horizontalResults = arView.arView.session.raycast(horizontalRaycastQuery)
            
            // Create a raycast query from the touch location, allowing estimated planes and aligning with vertical planes
            let verticalRaycastQuery = arView.arView.raycastQuery(from: touch.location(in: arView.arView), allowing: .estimatedPlane, alignment: .vertical)!
            let verticalResults = arView.arView.session.raycast(verticalRaycastQuery)
            
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
            let sphereNode = SCNNode()
            sphereNode.geometry = SCNSphere(radius: 1.0)
            sphereNode.position = position
            
            // Call the createSphereNode function with the position parameter
            var nodes = [SCNNode]()
            var previousNode: SCNNode?
            createSphereNode(at: position, nodes: &nodes, previousNode: &previousNode)
        }

        
        func createSphereNode(at position: SCNVector3, nodes: inout [SCNNode], previousNode: inout SCNNode?) {
            // Create a new sphere node at the touch position
            let sphereNode = SCNNode()
            sphereNode.geometry = SCNSphere(radius: 0.01)
            sphereNode.position = position
            
            // Add the sphere node to the scene
            parent.arView.scene.rootNode.addChildNode(sphereNode)

            
            // Update the previous node to be the current sphere node for the next point
            nodes.append(sphereNode)
            previousNode = sphereNode
        }


    }

}

struct ContentView: View {
    var body: some View {
        ARView()
    }
}

struct ARView: View {
    @State private var nodes: [SCNNode] = []
    let arView = ARViewWrapper().arView // Access the ARSCNView
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                ARViewWrapper()
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
            
            HStack {
                Button("Save") {
                    save()
                }
                .padding()
                
                Button("Load") {
                    load()
                }
                .padding()
                
                Button("Clear") {
                    clear()
                }
                .padding()
            }
        }
    }
    
    func save() {
        // Save nodes to file
    }
    
    func load() {
        // Load nodes from file
    }
    
    func clear() {
        // Clear nodes
    }
}
*/

//
//  Utilities.swift
//  AR-App
//
//  Created by Jack Burrows on 09/03/2023.
//

import Foundation
import SceneKit

class Utilities {
    // Debugging purposes: Check if 2 arrays are equal
    internal func areArraysEqual(_ array1: [SCNNode], _ array2: [SCNNode]) -> Bool {
        return array1 == array2
    }
    
    // Debugging purposes: Return the type of an array
    private func getType<T>(_ array: [T]) -> String {
        return "\(type(of: array))"
    }
}

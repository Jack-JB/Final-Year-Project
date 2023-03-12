//
//  Utilities.swift
//  AR-App
//
//  Created by Jack Burrows on 09/03/2023.
//

import Foundation
import SceneKit

// This class has been used for debugging functions throughout development
// It contains no production code that will be called within the application
internal class Utilities {
    
    internal func areArraysEqual(_ array1: [SCNNode], _ array2: [SCNNode]) -> Bool {
        return array1 == array2
    }
    
    internal func getType<T>(_ array: [T]) -> String {
        return "\(type(of: array))"
    }
}

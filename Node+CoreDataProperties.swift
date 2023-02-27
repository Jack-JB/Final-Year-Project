//
//  Node+CoreDataProperties.swift
//  AR-App
//
//  Created by Jack Burrows on 27/02/2023.
//
//

import Foundation
import CoreData


extension Node {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Node> {
        return NSFetchRequest<Node>(entityName: "Node")
    }

    @NSManaged public var name: String?
    @NSManaged public var positionX: Float
    @NSManaged public var positionY: Float
    @NSManaged public var positionZ: Float
    @NSManaged public var rotationX: Float
    @NSManaged public var rotationY: Float
    @NSManaged public var rotationZ: Float
    @NSManaged public var scaleX: Float
    @NSManaged public var scaleY: Float
    @NSManaged public var scaleZ: Float

}

extension Node : Identifiable {

}

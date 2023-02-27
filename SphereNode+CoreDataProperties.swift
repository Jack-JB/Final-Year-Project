//
//  SphereNode+CoreDataProperties.swift
//  AR-App
//
//  Created by Jack Burrows on 27/02/2023.
//
//

import Foundation
import CoreData


extension SphereNode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SphereNode> {
        return NSFetchRequest<SphereNode>(entityName: "SphereNode")
    }

    @NSManaged public var x: Float
    @NSManaged public var y: Float
    @NSManaged public var z: Float

}

extension SphereNode : Identifiable {

}

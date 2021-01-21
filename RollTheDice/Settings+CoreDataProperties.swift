//
//  Settings+CoreDataProperties.swift
//  RollTheDice
//
//  Created by Waveline Media on 1/21/21.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var currentFaces: Int16
    @NSManaged public var hapticControl: Bool

}

extension Settings : Identifiable {

}

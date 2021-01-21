//
//  DiceResult+CoreDataProperties.swift
//  RollTheDice
//
//  Created by Waveline Media on 1/21/21.
//
//

import Foundation
import CoreData


extension DiceResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiceResult> {
        return NSFetchRequest<DiceResult>(entityName: "DiceResult")
    }

    @NSManaged public var faces: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var result: Int16

}

extension DiceResult : Identifiable {

}

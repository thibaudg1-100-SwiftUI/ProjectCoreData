//
//  Country+CoreDataProperties.swift
//  ProjectCoreData
//
//  Created by RqwerKnot on 07/03/2022.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var shortName: String?
    @NSManaged public var fullName: String?
    @NSManaged public var candy: NSSet?
    
    public var wrappedShortName: String {
        shortName ?? "Unknown Country"
    }

    public var wrappedFullName: String {
        fullName ?? "Unknown Country"
    }
    
    // Swift UI ForEach requires an array to work with
    // Currently an NSSet of 'undefined something' is created
    public var candyArray: [Candy] {
        // first let's create a Set of Candy out of an NSSet of 'undefined something'
        // if it fails, we return an empty Set of Candy
        let set = candy as? Set<Candy> ?? []
        // let's sort the Set so that it becomes an Array to be used with ForEach:
        // we cannot use '<' operator directly here, because we are not sorting built-in Swift types (like String)
        return set.sorted {
            $0.wrappedName < $1.wrappedName // this is the custom sorting closure
        }
    }

}

// MARK: Generated accessors for candy
extension Country {

    @objc(addCandyObject:)
    @NSManaged public func addToCandy(_ value: Candy)

    @objc(removeCandyObject:)
    @NSManaged public func removeFromCandy(_ value: Candy)

    @objc(addCandy:)
    @NSManaged public func addToCandy(_ values: NSSet)

    @objc(removeCandy:)
    @NSManaged public func removeFromCandy(_ values: NSSet)

}

extension Country : Identifiable {

}

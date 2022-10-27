//
//  Movie+CoreDataProperties.swift
//  ProjectCoreData
//
//  Created by RqwerKnot on 04/03/2022.
//
//

import Foundation
import CoreData

// This file "appear" when selecting 'Manual/None' Codegen in CoreData Model Editor for an Entity
// Then Menu 'Editor' and 'Create NSManagedObject Subclass...'

// Do not switch back to default Codegen or 'Create NSManagedObject Subclass...' again, otherwise it will trhow away all yur edits done below

extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    // @NSManaged is not a Swift property wrapper
    // It is an Objective-C CoreData keyword
    // Those are not 3 Swift properties as they seem but actually some Ob
    @NSManaged public var title: String?
    @NSManaged public var director: String?
    @NSManaged public var year: Int16 // year is not optional by default, which means Core Data will assume a default value for us
    
    // You could replace the default implementation with what follows to avoid optionals
    // But the way CoreData works means there is no guarantee that you would not get any nil or weird value when fetching data from the DB in the future
    // While it's "OK" for a learning project, it's not recommended, better use computed properties (see below)
    // Declaring 'title' and 'director' as non-optional will work for avoiding nil-coalescing, but won't prevent to create a new Entity with attribute set to nil value
    // Another problem is that CoreData is lazy: it doesn't really load the data from the DB so that it's available for the UI
    // It only says "yes this is available in DB" but only load the data when actually used
    // This means that even something in DB defined as non-optional is definitely here and non-optional, it can be seen as nil from the UI perspective at some point in the app lifecycle
    
    
//    @NSManaged public var title: String // without a '?'
//    @NSManaged public var director: String // without a '?'
    
    public var titleUnwrapped: String {
        title ?? "Unknown title"
    }
    
    public var directorUnwrapped: String {
        director ?? "Unknown title"
    }

}

extension Movie : Identifiable {

}

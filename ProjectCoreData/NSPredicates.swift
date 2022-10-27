//
//  NSPredicates.swift
//  ProjectCoreData
//
//  Created by RqwerKnot on 07/03/2022.
//

import SwiftUI

struct NSPredicates: View {
    @Environment(\.managedObjectContext) var moc
    // no predicate = no filtering
    @FetchRequest(sortDescriptors: [], predicate: nil) var ships: FetchedResults<Ship>
    
    // with a simple predicate:
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe == 'Star Wars'")) var ships2: FetchedResults<Ship>
    
    // That gets complicated if your data includes quote marks, so it’s more common to use special syntax instead: `%@‘ means “insert some data here”, and allows us to provide that data as a parameter to the predicate rather than inline.
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe == %@", "Star Wars")) var ships3: FetchedResults<Ship>
    
    // comparison operators work as well, this will return any names that starts with a letter before F:
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "name < %@", "F")) var ships4: FetchedResults<Ship>
    
    // we could use an IN predicate to check whether the universe is one of three options from an array:
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe IN %@", ["Aliens", "Firefly", "Star Trek"])) var ships5: FetchedResults<Ship>
    
    // predicates to examine part of a string, using operators such as BEGINSWITH:
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "name BEGINSWITH %@", "E")) var ships6: FetchedResults<Ship>
    // That predicate is case-sensitive; if you want to ignore case you need to modify it to this:
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "name BEGINSWITH[c] %@", "e")) var ships7: FetchedResults<Ship>
    
    // CONTAINS[c] works similarly, except rather than starting with your substring it can be anywhere inside the attribute:
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "name CONTAINS[c] %@", "X")) var ships8: FetchedResults<Ship>
    
    // you can flip predicates around using NOT, to get the inverse of their regular behavior:
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "NOT name CONTAINS[c] %@", "t")) var ships9: FetchedResults<Ship>
    
    // If you need more complicated predicates, join them using AND to build up as much precision as you need, or add an import for Core Data and take a look at NSCompoundPredicate – it lets you build one predicate out of several smaller ones.
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(ships, id: \.self) { ship in
                        Text(ship.name ?? "Unknown name")
                    }
                } header: {
                    Text("No predicate")
                }
                
                Section {
                    ForEach(ships2, id: \.self) { ship in
                        Text(ship.name ??  "Unknown name")
                    }
                } header: {
                    Text("Universe: Star Wars")
                }
                
                Section {
                    ForEach(ships4, id: \.self) { ship in
                        Text(ship.name ??  "Unknown name")
                    }
                } header: {
                    Text("Ship name's first letter before 'F'")
                }
                
                Section {
                    ForEach(ships5, id: \.self) { ship in
                        Text(ship.name ??  "Unknown name")
                    }
                } header: {
                    Text("Universe in [\"Aliens\", \"Firefly\", \"Star Trek\"]")
                }
                
                Section {
                    ForEach(ships6, id: \.self) { ship in
                        Text(ship.name ??  "Unknown name")
                    }
                } header: {
                    Text("Name begins with capital 'E'")
                }
                
                Section {
                    ForEach(ships8, id: \.self) { ship in
                        Text(ship.name ??  "Unknown name")
                    }
                } header: {
                    Text("Name contains case-insentive 'X'")
                }
                
                Section {
                    ForEach(ships9, id: \.self) { ship in
                        Text(ship.name ??  "Unknown name")
                    }
                } header: {
                    Text("Name doesn't contains 't'")
                }

            }
            
            Button("Add Examples") {
                let ship1 = Ship(context: moc)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"

                let ship2 = Ship(context: moc)
                ship2.name = "Defiant"
                ship2.universe = "Star Trek"

                let ship3 = Ship(context: moc)
                ship3.name = "Millennium Falcon"
                ship3.universe = "Star Wars"

                let ship4 = Ship(context: moc)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"
            }
        }
    }
}

struct NSPredicates_Previews: PreviewProvider {
    
    static private var dataController = DataController()
    
    static var previews: some View {
        NSPredicates()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}

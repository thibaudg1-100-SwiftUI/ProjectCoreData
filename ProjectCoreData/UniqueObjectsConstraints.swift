//
//  UniqueObjectsConstraints.swift
//  ProjectCoreData
//
//  Created by RqwerKnot on 04/03/2022.
//

import SwiftUI

struct UniqueObjectsConstraints: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var wizards: FetchedResults<Wizard>
    
    @State private var counter = 0
    
    var body: some View {
        VStack {
            
            // Showing a list of all wizards in DB
            List(wizards, id: \.self) { wizard in
                HStack {
                    Text(wizard.name ?? "Unknown")
                    Spacer()
                    Text("\(wizard.counter)")
                }
            }
            
            HStack {
            // Adding a new Wizard to live context (moc)
            // with the same name everytime... creating duplicates
            Button("Add") {
                counter += 1
                let wizard = Wizard(context: moc)
                wizard.name = "Harry Potter"
                wizard.counter = Int16(counter) // just to understand how the merge policy is applied
            }
                
            Text("\(counter)")
            
            // Save button
            // it won't work at first if there has been a constraint on 'name' attribute for Entity 'Wizard'
            // For we asked CoreData to prevent duplicates in persistent store
            // And CoreData spotted a colision
            // To work around the issue, we have to declare a merge policy in DataController
            Button("Save") {
                do {
                    try moc.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
            }
        }
    }
}

struct UniqueObjectsConstraints_Previews: PreviewProvider {
    
    static private var dataController = DataController()
    
    static var previews: some View {
        UniqueObjectsConstraints()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            
    }
}

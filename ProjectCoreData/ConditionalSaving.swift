//
//  ConditionalSaving.swift
//  ProjectCoreData
//
//  Created by RqwerKnot on 04/03/2022.
//

import SwiftUI

struct ConditionalSaving: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) private var pupils: FetchedResults<Pupil>
    
    var body: some View {
        Button("Save") {
            let newPupil = Pupil(context: moc)
            newPupil.name = "Toto"
            
            // always use to conditonal saving to save resources and increase performance:
            if moc.hasChanges {
                try? moc.save()
            }
        }
    }
}

struct ConditionalSaving_Previews: PreviewProvider {
    
    static private var dataController = DataController()
    
    static var previews: some View {
        ConditionalSaving()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}

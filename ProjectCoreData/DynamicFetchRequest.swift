//
//  DynamicFetchRequest.swift
//  ProjectCoreData
//
//  Created by RqwerKnot on 07/03/2022.
//

import SwiftUI

struct DynamicFetchRequest: View {
    
    @Environment(\.managedObjectContext) var moc
    @State private var lastNameFilter = "A"
    
    // only used for Apple version:
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "lastName BEGINSWITH %@", "A")) private var singers: FetchedResults<Singer>
    
    
    var body: some View {
        VStack {
            //1// HWS way of managing dynamic filters for Fetch Requests:
            FilteredList(filter: lastNameFilter)
            
            //2// my way: (not sure if it is resources efficient though..)
            // and it requires that the fetchrequest var doesn't have private access
            FilteredList2(fetchRequest: FetchRequest<Singer>(sortDescriptors: [], predicate: NSPredicate(format: "lastName BEGINSWITH %@", lastNameFilter)))
            
            //3// Apple doc's way:
            List(singers, id: \.self) { singer in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }.onChange(of: lastNameFilter) { newValue in
                singers.nsPredicate = lastNameFilter.isEmpty
                                        ? nil
                                        : NSPredicate(format: "lastName BEGINSWITH %@", newValue)
            }
            
            //4// Using an evolved generic version of FilteredList:
            GenericFilteredList(sorting: [SortDescriptor<Singer>(\.lastName, order: SortOrder.reverse)], filterKey: "lastName", predicate: .containsCaseInsensitive, filterValue: lastNameFilter) { (singer: Singer) in
                // adding 2 views like below will work when the closure definition is prefixed by '@ViewBuilder' which will compose the 2 views using the parent container (in this case: 'List' from the var body of the 'GenericFilteredList')
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }
            

            Button("Add Examples") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"

                let ed = Singer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"

                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"

//                try? moc.save()
            }

            Button("Show A") {
                lastNameFilter = "A"
            }

            Button("Show S") {
                lastNameFilter = "S"
            }
        }
    }
}

struct DynamicFetchRequest_Previews: PreviewProvider {
    
    static private var dataController = DataController()
    
    static var previews: some View {
        DynamicFetchRequest()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}

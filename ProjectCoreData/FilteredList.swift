//
//  FilteredList.swift
//  ProjectCoreData
//
//  Created by RqwerKnot on 07/03/2022.
//

import SwiftUI
import CoreData

struct FilteredList: View {
    
    // this is not a complete Fecth Request, this is a View property that will get a value from the parent View call or through this view's own initializer
    @FetchRequest private var fetchRequest: FetchedResults<Singer>
    
    var body: some View {
        List(fetchRequest, id: \.self) { singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
    
    init(filter: String) {
        // That will run a fetch request using the current managed object context. Because this view will be used inside the Parent View, we don’t even need to inject a managed object context into the environment – it will inherit the context from the Parent View.
        // using '_' in front of the property name means we’re not writing to the fetched results object inside our fetch request, but instead writing a wholly new fetch request
        // So, by assigning to _fetchRequest, we aren’t trying to say “here’s a whole bunch of new results we want to you to use,” but instead we’re telling Swift we want to change the whole fetch request itself
        _fetchRequest = FetchRequest<Singer>(sortDescriptors: [], predicate: NSPredicate(format: "lastName BEGINSWITH %@", filter))
    }
}

struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredList(filter: "A")
    }
}

struct FilteredList2: View {
    
    // this is not a complete Fecth Request, this is a View property that will get a value from the parent View call or through this view's own initializer
    @FetchRequest var fetchRequest: FetchedResults<Singer>
    
    var body: some View {
        List(fetchRequest, id: \.self) { singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
}

struct GenericFilteredList<T: NSManagedObject, Content: View>: View {
    
    @FetchRequest private var items: FetchedResults<T>
    
    let content: (T) -> Content

    var body: some View {
        
            List(items, id: \.self) { item in
                content(item)
            }
        
    }
    
    // @ViewBuilder lets our containing view (whatever is using the list) send in multiple views if they want
    // @escaping says the closure will be stored away and used later, which means Swift needs to take care of its memory
    // providing a default value for 'sorting': no sorting at all
    init(sorting: [SortDescriptor<T>] = [], filterKey: String, predicate: Predicate, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        
        let predicateString = predicate.rawValue
        
        _items = FetchRequest<T>(sortDescriptors: sorting, predicate: NSPredicate(format: "%K \(predicateString) %@", filterKey, filterValue))
        
        self.content = content
    }
    
}

enum Predicate: String {
    case beginsWith = "BEGINSWITH"
    case beginsWithCaseInsensitive = "BEGINSWITH[c]"
    case contains = "CONTAINS"
    case containsCaseInsensitive = "CONTAINS[c]"
}

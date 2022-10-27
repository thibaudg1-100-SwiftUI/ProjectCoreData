//
//  SelfKeypathHashable.swift
//  ProjectCoreData
//
//  Created by RqwerKnot on 04/03/2022.
//

import SwiftUI
import CoreData

struct Student {
    let name: String // String type conforms to Hashable by default
    
    init(_ name: String) {
        self.name = name
    }
}

// you can make a struct conforms to Hashable with no effort as long as all its properties already conform to Hashable
struct Person: Hashable {
    let firstName: String
    let familyName: String
}

struct SelfKeypathHashable: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) private var pupils: FetchedResults<Pupil>
    
    let students = [Student("Harry"), Student("Hermione"), Student("Ron")]
    
    let persons = [Person(firstName: "Bilbo", familyName: "Baggins"), Person(firstName: "Frodo", familyName: "Baggins")]
    
    var body: some View {
        List {
            ForEach([0,2,4,6,8], id: \.self){
                // here we indicate that the uniqueness of each item of the array is itself
                // meaning that each item must conform to Hashable protocol
                // and every item will be hashed and the resulting hash will be used for IDing the items of the array
                // but 2 identical hashable items produce the same hash, meaning that the ForEach will produce undefined results in case our array contains doublons or more identical items
                // Swift built-in 'Int' struct conforms to Hashable by design
                Text("\($0) is even")
            }
            
            ForEach(students, id: \.name) {
                // here we declare that ForEach will uniquely ID its items using the 'name' property of each item
                // it works in this case because 'name' is String and Swift built-in 'String' type conforms to Hashable
                // But if 2 or more items of the 'students' array are identical, this will produce undefined results
                Text($0.name)
            }
            
            ForEach(persons, id: \.self) {
                // we can use the '\.self' keypath here each item (struct Person) of 'persons' array conforms to Hashable
                // but again if two items of type Person produce the same hash value, there will be undefined results/behaviors
                Text($0.firstName + " " + $0.familyName)
            }
            
            ForEach(pupils, id: \.self) {
                // When using CoreData, Xcode automatically generates a class for our managed objects that conforms to Hashable
                // We can then use '\.self' in the ForEach to get a hash value for those objects and uniquely identify ForEach items
                // But once again, if two or more managed objects are identical they will produce the same hash value and we will get undefined results with the ForEach view
                Text($0.name ?? "nil")
            }
            
            ForEach(pupils) {
                // To workaround these identification issues, when using CoreData managed objects, CoreData automatically add ID attribute to our Entities in the background that makes the Object conform to Identifiable, and managed objects can then be used with 'ForEach' without using 'id:' init and Hashable conformance
                // Also the ID that CoreData generates is sequential and much better suited than UUID for indexing database
                Text($0.name ?? "nil")
            }
        }
        .onAppear(perform: createPupils)
    }
    
    func createPupils() {
        let pupil1 = Pupil(context: moc)
        pupil1.name = "Tom"
        
        let pupil2 = Pupil(context: moc)
        pupil2.name = "Jerry"
    }
}

struct SelfKeypathHashable_Previews: PreviewProvider {

    static private var dataController = DataController()

    static var previews: some View {
        SelfKeypathHashable()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}

//
//  ProjectCoreDataApp.swift
//  ProjectCoreData
//
//  Created by RqwerKnot on 04/03/2022.
//

import SwiftUI

@main
struct ProjectCoreDataApp: App {
    
    @StateObject private var dataController = DataController()
    
    let learning = true
    
    var body: some Scene {
        WindowGroup {
            if learning{
                UniqueObjectsConstraints()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
            } else {
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
            }
            
        }
    }
}

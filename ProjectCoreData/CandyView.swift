//
//  CandyView.swift
//  ProjectCoreData
//
//  Created by RqwerKnot on 07/03/2022.
//

import SwiftUI

struct CandyView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.fullName)]) var countries: FetchedResults<Country>
    
    var body: some View {
        VStack {
            List {
                ForEach(countries, id: \.self) { country in
                    Section(country.wrappedFullName) {
                        ForEach(country.candyArray, id: \.self) { candy in
                            Text(candy.wrappedName)
                        }
                    }
                }
            }

            HStack {
                Button("Add") {
                    
                    let candy1 = Candy(context: moc)
                    candy1.name = "Mars"
                    candy1.origin = Country(context: moc)
                    candy1.origin?.shortName = "UK"
                    candy1.origin?.fullName = "United Kingdom"

                    let candy2 = Candy(context: moc)
                    candy2.name = "KitKat"
                    candy2.origin = Country(context: moc)
                    candy2.origin?.shortName = "UK"
                    candy2.origin?.fullName = "United Kingdom"

                    let candy3 = Candy(context: moc)
                    candy3.name = "Twix"
                    candy3.origin = Country(context: moc)
                    candy3.origin?.shortName = "UK"
                    candy3.origin?.fullName = "United Kingdom"

                    let candy4 = Candy(context: moc)
                    candy4.name = "Toblerone"
                    candy4.origin = Country(context: moc)
                    candy4.origin?.shortName = "CH"
                    candy4.origin?.fullName = "Switzerland"
                                    
                    do {
                        try moc.save()
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
                Spacer()
                Button("Delete all...", role: .destructive) {
                    for country in countries {
                        moc.delete(country)
                    }
                    
                    try? moc.save()
                }
            }
            .padding()
        }
        .onAppear {
            for country in countries {
                moc.delete(country)
            }
            
            try? moc.save()
        }
    }
}

struct CandyView_Previews: PreviewProvider {
    
    static private var dataController = DataController()
    
    static var previews: some View {
        CandyView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}

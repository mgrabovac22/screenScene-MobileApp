//
//  ContentView.swift
//  Screen Scene
//
//  Created by RAMPU on 17.11.2024..
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.modelContext) var context
    
    @Query private var items: [Movie]
    var body: some View {
        VStack {
            Text("Tap on this button to add data")
            Button("Add an item"){
                addItem()
            }
        }
        .padding()
    }
    
    List {
        ForEach(items){
            item in Text(item.name)
        }
    }
    
    func addItem() {
        let item = Movie(name: "New movie", releaseDate:   Date.now(), genre: "actions")
        
        context.Insert(item)
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  TakeHome
//
//  Created by Nicolas Cobelo on 20/06/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        HomeView(dataController: dataController)
    }
}

#Preview {
    ContentView()
}

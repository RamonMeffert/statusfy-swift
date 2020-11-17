//
//  ContentView.swift
//  SwiftStatusfy
//
//  Created by Ramon Meffert on 17/11/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            Text("Hello, world!").padding()
            Button("Ok", action: {
            }).padding()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

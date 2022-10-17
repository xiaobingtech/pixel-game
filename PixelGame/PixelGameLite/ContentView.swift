//
//  ContentView.swift
//  PixelGameLite
//
//  Created by 韩云智 on 2022/10/17.
//

import SwiftUI

struct ContentView: View {
    @State var color: Color = .accentColor
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(color)
            Text("Hello, world!")
        }
        .padding()
        .onTapGesture {
            AdRewarded.load {
                color = .red
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

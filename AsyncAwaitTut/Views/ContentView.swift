//
//  ContentView.swift
//  AsyncAwaitTut
//
//  Created by admin on 18.09.2024.
//

import SwiftUI
import OrderedCollections

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        List(viewModel.movies) { movie in
//            MovieRow(movie: movie, viewModel: viewModel)
            MovieRow2(movie: movie)
        }
        .listStyle(.plain)
        .onAppear(perform: {
            viewModel.downloadFirst30Movies()
        })
    }
}

#Preview {
    ContentView()
}

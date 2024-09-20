//
//  MoviewRow2.swift
//  AsyncAwaitTut
//
//  Created by admin on 19.09.2024.
//

import SwiftUI

struct MovieRow2: View {
    let movie: MovieModel
    @StateObject var viewModel: MovieRowVM = MovieRowVM()
    
    var body: some View {
        HStack {
            //image
            if viewModel.image == nil {
                ProgressView()
                    .frame(width: 150, height: 225)
                    .background(.gray)
                    .tint(.white)
                    .onAppear(perform: {
//                        viewModel.fetchThumbnail(for: movie) { image, _ in
//                            if let image = image {
//                                self.image = image
//                            }
//
//                        }
                        print("DEBUG: onAppear START")
                        viewModel.getImage(for: movie)
                        print("DEBUG: onAppear END")
                    })
            } else {
                Image(uiImage: viewModel.image!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 225)
                    .onDisappear(perform: {
                        viewModel.image = nil
                    })
            }

            Spacer()
            // name
            Text(movie.title ?? " DEFAULT ")
                .font(.title)
                .fontWeight(.semibold)
            
            Spacer()
        }
    }
}

#Preview {
    MovieRow(movie: MovieModel.mockMovie, viewModel: ViewModel())
}

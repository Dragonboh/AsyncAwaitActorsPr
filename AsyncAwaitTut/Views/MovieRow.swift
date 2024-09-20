//
//  MovieRow.swift
//  AsyncAwaitTut
//
//  Created by admin on 18.09.2024.
//

import SwiftUI

struct MovieRow: View {
    let movie: MovieModel
    @State private var image: UIImage?
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            //image
            if image == nil {
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
                        Task {
                            do {
                                print("DEBUG: onAppear Task START")
                                image = try await viewModel.fetchThumbnail(for: movie)
                                print("DEBUG: onAppear Task END")
                            } catch {
                                print(error)
                            }
                        }
                        print("DEBUG: onAppear END")
                    })
            } else {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 225)
                    .onDisappear(perform: {
                        image = nil
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

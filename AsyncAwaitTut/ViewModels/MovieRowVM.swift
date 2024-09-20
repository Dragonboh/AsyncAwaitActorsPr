//
//  MovieRowVM.swift
//  AsyncAwaitTut
//
//  Created by admin on 19.09.2024.
//

import UIKit

class MovieRowVM: ObservableObject {
    @Published var image: UIImage?
    private let moviesService = MoviesService()
    
    init() {
//        downloadFirst30Movies()
    }
    
    @MainActor
    func getImage(for movie: MovieModel) {
        Task {
            do {
                print("DEBUG: onAppear Task START")
                
                image = try await fetchThumbnail(for: movie)
                print("DEBUG: onAppear Task END")
            } catch {
                print(error)
            }
        }
    }
    
    func fetchThumbnail(for movie: MovieModel) async throws -> UIImage {
        print("DEBUG: onAppear Task fetchThumbnail START")
        guard let poster = movie.posterPath else { throw FetchError.badID }
//        print(Unmanaged.passUnretained(Thread).toOpaque())
//        print(Thread.current)
        let request = thumbnailURLRequest(for: poster)
        let (data, response) = try await URLSession.shared.data(for: request)
        print("DEBUG: onAppear Task fetchThumbnail RESUME")
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badID }
        let maybeImage = UIImage(data: data)
        print("DEBUG: onAppear Task thumbnail ")
        guard let thumbnail = await maybeImage?.thumbnail else { throw FetchError.badImage }
        print("DEBUG: onAppear Task fetchThumbnail RESUME")
        return thumbnail
    }
    
    func fetchThumbnail(for movie: MovieModel, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let poster = movie.posterPath else {
            completion(nil, FetchError.badID)
            return
        }
        let request = thumbnailURLRequest(for: poster)
        print("fetch image for \(movie.title ?? "")")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(nil, FetchError.badID)
            } else {
                guard let image = UIImage(data: data!) else {
                    completion(nil, FetchError.badImage)
                    return
                }
                completion(image, nil)
//                image.prepareThumbnail(of: CGSize(width: 150, height: 225)) { thumbnail in
//                    guard let thumbnail = thumbnail else {
//                        completion(nil, FetchError.badImage)
//                        return
//                    }
//                    completion(thumbnail, nil)
//                }
            }
        }
        task.resume()
    }
    
    private func thumbnailURLRequest(for id: String) -> URLRequest {
        var imageURL = "https://image.tmdb.org/t/p/original"
        imageURL.append(id)
        let url = URLRequest(url: .init(string: imageURL)!)
        return url
    }
}

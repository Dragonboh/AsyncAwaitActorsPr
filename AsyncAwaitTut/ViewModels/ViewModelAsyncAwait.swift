//
//  ViewModelAsyncAwait.swift
//  AsyncAwaitTut
//
//  Created by admin on 19.09.2024.
//

import UIKit
import OrderedCollections

class ViewModelAsyncAwait: ObservableObject {
    @Published var movies: OrderedSet<MovieModel> = []
    private let moviesService = MoviesService()
    
    init() {
//        downloadFirst30Movies()
    }
    
    func downloadFirst30Movies() {
        print("start downloading movies")
        fetchMovies(page: 1) { [weak self] result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self?.movies.append(contentsOf: success)
                }
            case .failure(_):
                print("DEBUG: downloadFirst30Movies ERROR")
            }
        }
    }
    
    private func fetchMovies(page: Int, complition: @escaping (Result<[MovieModel], CustomError>) -> Void) {
        moviesService.fetchMovies(page: page) { [weak self] result in
            switch result {
            case .success(let success):
                complition(.success(success))
                if page < 3 {
                    self?.fetchMovies(page: page + 1, complition: complition)
                }
            case .failure(_):
                print("DEBUG: downloadFirst30Movies ERROR On page = \(page)")
            }
        }
    }
    
    func fetchThumbnail(for movie: MovieModel) async throws -> UIImage {
        guard let poster = movie.posterPath else { throw FetchError.badID }
//        print(Unmanaged.passUnretained(Thread).toOpaque())
//        print(Thread.current)
        let request = thumbnailURLRequest(for: poster)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badID }
        let maybeImage = UIImage(data: data)
        guard let thumbnail = await maybeImage?.thumbnail else { throw FetchError.badImage }
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



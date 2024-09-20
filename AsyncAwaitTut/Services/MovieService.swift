//
//  MovieService.swift
//  AsyncAwaitTut
//
//  Created by admin on 18.09.2024.
//

import Foundation

final class MoviesService {
    
    private let authorizationToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4MzU2NDVhMzAyN2VhYzFhOTc3YmRlZTc0ZmQ4MWEzZCIsIm5iZiI6MTcyMjAxMTE3Mi41MTEzODEsInN1YiI6IjY2YTNjYmNhODQ1NjM4YmYxOTcwOGMzOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Ma0Y2QR4Sbv9WLcZ7uDCsq0_RwL-0ifo82gI5fZAVEw"
    
//    var counter = 1
//    var searchCounter = 0
    
    func fetchMovies(page: Int, complition: @escaping (Result<[MovieModel], CustomError>) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie")!
        
        //Mock Comments. Use this for simulate errors in particular request try
        
//        if counter < 2 && counter > 0 {
//            url = URL(string: "https://api.themoviedb.org/3/discover/movie1212312312")!
//        }
        
//        if counter > 12 {
//            url = URL(string: "https://api.themoviedb.org/3/discover/movie1212312312")!
//        }
//        counter += 1
        
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "include_adult", value: "false"),
          URLQueryItem(name: "include_video", value: "false"),
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "\(page)")
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": authorizationToken
        ]
        
        performMultiResponseRequest(request, complition: complition)
    }
}

private extension MoviesService {
    func performSingleResponseRequest<DecodedType: Codable>(_ request: URLRequest, complition: @escaping (Result<DecodedType, CustomError>) -> Void) {
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let self = self else { return }
            switch checkResultsForErrors(data, response, error) {
            case .failure(let error):
                complition(.failure(error))
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode(DecodedType.self, from: data)
                    complition(.success(results))
                } catch {
                    print("DEBUG: cannot decode JSON, error: \(error.localizedDescription)")
                    complition(.failure(.error(error.localizedDescription)))
                }
            }
        }.resume()
    }
    
    func performMultiResponseRequest<DecodedType: Codable>(_ request: URLRequest, complition: @escaping (Result<[DecodedType], CustomError>) -> Void) {
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let self = self else { return }
            switch checkResultsForErrors(data, response, error) {
            case .failure(let error):
                complition(.failure(error))
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode(Response<[DecodedType]>.self, from: data)
                    complition(.success(results.results))
                } catch {
                    print("DEBUG: cannot decode JSON, error: \(error.localizedDescription)")
                    complition(.failure(.error(error.localizedDescription)))
                }
            }
            
        }.resume()
    }
    
    func checkResultsForErrors(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Result<Data, CustomError> {
        if let error = error {
            return .failure(.error("Error in getting popular movies, error: \(error.localizedDescription)"))
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("DEBUG: bad response")
            return .failure(.error("bad response"))
        }
        
        guard let data = data else {
            print("DEBUG: no data")
            return .failure(.error("no response data"))
        }
        
        return .success(data)
    }
}

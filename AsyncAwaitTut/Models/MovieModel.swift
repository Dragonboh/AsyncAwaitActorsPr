//
//  MovieModel.swift
//  AsyncAwaitTut
//
//  Created by admin on 18.09.2024.
//

import Foundation

struct Response<RR: Codable>: Codable {
    let results: RR
}

struct MovieModel: Codable, Hashable, Identifiable {
    let id: Int
    let backdropPath: String?
    let title: String?
    let releaseDate: String?
    let rating: Double?
    let popularity: Double?
    let posterPath: String?
    
    init(id: Int,
         backdropPath: String? = nil,
         title: String? = nil,
         releaseDate: String? = nil,
         rating: Double? = nil, popularity: Double? = nil, posterPath: String? = nil) {
        
        self.id = id
        self.backdropPath = backdropPath
        self.title = title
        self.releaseDate = releaseDate
        self.rating = rating
        self.popularity = popularity
        self.posterPath = posterPath
    }
    enum CodingKeys: String, CodingKey {
        case id, popularity
        case backdropPath = "backdrop_path"
        case title = "original_title"
        case releaseDate = "release_date"
        case rating = "vote_average"
        case posterPath = "poster_path"
    }
    
    static let mockMovie = MovieModel(id: 0, title: "Deadpool", posterPath: "DeadPool")
    
    static let mockMovieArray = [MovieModel(id: 0, title: "Deadpool", posterPath: "DeadPool"),
                                 MovieModel(id: 1, title: "Deadpool", posterPath: "DeadPool"),
                                 MovieModel(id: 2, title: "Deadpool", posterPath: "DeadPool"),
                                 MovieModel(id: 3, title: "Deadpool", posterPath: "DeadPool"),
                                 MovieModel(id: 4, title: "Deadpool", posterPath: "DeadPool"),
                                 MovieModel(id: 5, title: "Deadpool", posterPath: "DeadPool"),
                                 MovieModel(id: 6, title: "Deadpool", posterPath: "DeadPool")]
}

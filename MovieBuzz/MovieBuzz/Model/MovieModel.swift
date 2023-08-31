//
//  MovieModel.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 30/08/23.
//

import Foundation

struct Movie: Codable, Equatable {
    let title: String
    let year: String
    let released: String
    let genre: String
    let director: String
    let actors: String
    let plot: String
    let language: String
    let poster: String
    let rating: [Rating]
    
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case released = "Released"
        case genre = "Genre"
        case director = "Director"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case poster = "Poster"
        case rating = "Ratings"
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.title < rhs.title
    }
}

struct Rating: Codable {
    let source: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

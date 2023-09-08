//
//  SectionModel.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 08/09/23.
//

import Foundation

/// Enumeration defining different section type.
enum SectionType: String, CaseIterable {
    case Year
    case Genre
    case Directors
    case Actors
    case AllMovies = "All Movies"
}

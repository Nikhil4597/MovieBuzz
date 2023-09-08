//
//  ItemType.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 08/09/23.
//

import Foundation

/// Enumeration defining different types of items.
enum ItemType: Equatable {
    case titleLabel(String)
    case movie(MovieModel)
    
    static func == (lhs: ItemType, rhs: ItemType) -> Bool {
        switch (lhs, rhs) {
        case let (.titleLabel(title1), .titleLabel(title2)):
            return title1 == title2
        case (.movie(let movie1), .movie(let movie2)):
            return movie1 == movie2
        default:
            return false
        }
    }
}

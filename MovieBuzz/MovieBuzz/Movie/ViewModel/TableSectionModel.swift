//
//  TableSectionModel.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 31/08/23.
//

import Foundation

class TableSectionModel {
    enum SectionType: String, CaseIterable {
        case Year, Genre, Directors, Actors, AllMovies
    }
    
    var sectionType: SectionType
    var itemType: [TableItemType]
    var opened: Bool
    
    enum TableItemType: Equatable {
        case titleLabel(String)
        case movie(Movie)
        
        static func == (lhs: TableSectionModel.TableItemType, rhs: TableSectionModel.TableItemType) -> Bool {
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
    
    init(sectionType: SectionType, itemType: [TableItemType], opened: Bool) {
        self.sectionType = sectionType
        self.itemType = itemType
        self.opened = opened
    }
}

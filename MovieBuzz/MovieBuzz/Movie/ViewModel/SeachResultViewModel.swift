//
//  SeachResultViewModel.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 08/09/23.
//

import Foundation

/// A coordinator protocol for handling movie selection and navigation.
protocol MovieSelectionCoordinator {
    func showMoviePreview(for movie: MovieModel)
}

/// ViewModel responsible for search results.
class SearchResultViewModel {
    private var movies: [MovieModel]?
    
    private let coordinator: MovieSelectionCoordinator
    
    init(coordinator: MovieSelectionCoordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - Public methdos
extension SearchResultViewModel {
    /**
     * Handles the selection of a movie tile.
     * - Parameter movie: The selected movie.
     */
    public func movieTileSelected(movie: MovieModel) {
        coordinator.showMoviePreview(for: movie)
    }
}

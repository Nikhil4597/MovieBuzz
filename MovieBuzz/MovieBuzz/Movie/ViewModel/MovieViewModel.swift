//
//  MovieViewModel.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 30/08/23.
//

import Foundation

protocol MovieViewModelDelegate: AnyObject {
    func updateMovieData(movies: [Movie])
}

class MovieViewModel {
    static let title = "Movie Database"
    weak var delegate: MovieViewModelDelegate?
    public let sections = ["Year",
                           "Genre",
                           "Directors",
                           "Actors",
                           "All Movies"]
    

    init() {
        getMovieData()
    }
}

// MARK: - Private methods
extension MovieViewModel {
    private func getMovieData() {
        APIService.shared.getMovies{ [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.delegate?.updateMovieData(movies: movies)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

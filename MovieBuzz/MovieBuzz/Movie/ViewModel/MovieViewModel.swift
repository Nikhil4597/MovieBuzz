//
//  MovieViewModel.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 30/08/23.
//

import Foundation

class MovieViewModel {
    private var movies: [MovieModel] = [] {
        didSet {
            configureSections()
        }
    }
    var updateMovies: (() -> Void) = {}
    var categoryMovieData: [SectionType: [String: [MovieModel]]] = [:]
    var sectionData: [SectionModel] = []
}

// MARK: - Private methods
extension MovieViewModel {
    private func configureSections() {
        configureMovieByYear()
        configureMovieByGenre()
        configureMovieByDirectors()
        configureMovieByActors()
        configureAllMovies()
        updateMovies()
    }
    
   /**
    * Generate section data for all movies categorized by year.
    */
    private func configureMovieByYear() {
        var moviesByYear: [String: [MovieModel]] = [:]
        
        movies.forEach({
            if moviesByYear[$0.year] != nil {
                moviesByYear[$0.year]?.append($0)
            } else {
                moviesByYear[$0.year] = []
                moviesByYear[$0.year]?.append($0)
            }
        })
        
        var labelTitles: [ItemType] = []
        
        for movieTitle in moviesByYear.keys {
            labelTitles.append(.titleLabel(movieTitle))
        }
        
        sectionData.append(SectionModel(sectionType: .Year, itemType: labelTitles, opened: false))
        
        categoryMovieData[.Year] = moviesByYear
    }
    
   /**
    * Generate section data for all movies categorized by genre.
    */
    private func configureMovieByGenre() {
        var moviesByGenre: [String: [MovieModel]] = [:]
        movies.forEach({ movie in
            movie.genre.components(separatedBy: ",")
                .forEach({
                    if moviesByGenre[$0] != nil {
                        moviesByGenre[$0]?.append(movie)
                    } else {
                        moviesByGenre[$0] = []
                        moviesByGenre[$0]?.append(movie)
                    }
                })
        })
        
        var labelTitles: [ItemType] = []
        
        for movieTitle in moviesByGenre.keys {
            labelTitles.append(.titleLabel(movieTitle))
        }
        
        sectionData.append(SectionModel(sectionType: .Year, itemType: labelTitles, opened: false))
        
        categoryMovieData[.Genre] = moviesByGenre
    }
    
   /**
    * Generate section data for all movies categorized by directors.
    */
    private func configureMovieByDirectors() {
        var moviesByDirector: [String: [MovieModel]] = [:]
        
        movies.forEach({ movie in
            movie.director.components(separatedBy: ",")
                .forEach({
                    if moviesByDirector[$0] != nil {
                        moviesByDirector[$0]?.append(movie)
                    } else {
                        moviesByDirector[$0] = []
                        moviesByDirector[$0]?.append(movie)
                    }
                })
        })
        
        var labelTitles: [ItemType] = []
        
        for movieTitle in moviesByDirector.keys {
            labelTitles.append(.titleLabel(movieTitle))
        }
        
        sectionData.append(SectionModel(sectionType: .Year, itemType: labelTitles, opened: false))
        
        categoryMovieData[.Directors] = moviesByDirector
    }

   /**
    * Generate section data for all movies categorized by actors.
    */
    private func configureMovieByActors() {
        var moviesByActor: [String: [MovieModel]] = [:]
        movies.forEach({ movie in
            movie.actors.components(separatedBy: ",")
                .forEach({
                    if moviesByActor[$0] != nil {
                        moviesByActor[$0]?.append(movie)
                    } else {
                        moviesByActor[$0] = []
                        moviesByActor[$0]?.append(movie)
                    }
                })
        })
        var labelTitles: [ItemType] = []
        
        for movieTitle in moviesByActor.keys {
            labelTitles.append(.titleLabel(movieTitle))
        }
        
        sectionData.append(SectionModel(sectionType: .Year, itemType: labelTitles, opened: false))

        categoryMovieData[.Actors] = moviesByActor
    }
    
   /**
    * Generate section data for all movies.
    */
    private func configureAllMovies() {
        var moviesByTitle: [String: [MovieModel]] = [:]
        var moviesItems: [ItemType] = []
        movies.forEach({
            moviesByTitle[$0.title]?.append($0)
            moviesItems.append(.movie($0))
        })
        
        sectionData.append(SectionModel(sectionType: .Year, itemType: moviesItems, opened: false))
        categoryMovieData[.AllMovies] = moviesByTitle
    }
}

// MARK: - Public methods
extension MovieViewModel {
    /**
     * - Retrieved the data from the bundle.
     */
    public func fetchMovieData() {
        APIService.shared.getMovies{ [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.updateMovies()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    /**
     * - Return - number of sections.
     */
    public func numberOfSection() -> Int {
        SectionType.allCases.count
    }
    
    /**
     * - Parameter section: The index of the section.
     * - Returns: The number of items in the specified section.
     */
    public func numberOfRowsInSection(_ section: Int) -> Int {
        if sectionData[section].opened {
            return sectionData[section].itemType.count
        } else {
            return 0
        }
    }
    
    /**
     * Updates search results based on the entered query.
     *
     * - Parameter query - Entered query.
     * - Parameter completion: A closure to pass the filtered data to the view.
     */
    public func updateSearchResults(query: String?, completion: @escaping([MovieModel]) -> Void) {
        guard let query = query,
        !query.trimmingCharacters(in: .whitespaces).isEmpty &&
        query.trimmingCharacters(in: .whitespaces).count > 1 else {
            completion([])
            return
        }
        
        let filteredMovies = movies.filter({
            return $0.title.localizedCaseInsensitiveContains(query) ||
            $0.actors.localizedCaseInsensitiveContains(query) ||
            $0.genre.localizedCaseInsensitiveContains(query) ||
            $0.director.localizedCaseInsensitiveContains(query)
        })
        
        completion(filteredMovies)
    }
}

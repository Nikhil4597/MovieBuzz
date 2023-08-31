//
//  ViewController.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 30/08/23.
//

import UIKit

class MovieViewController: UIViewController {
    private let viewModel: MovieViewModel = {
       let viewModel = MovieViewModel()
        return viewModel
    }()
    
    private var movies: [Movie]? = nil {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.configureHeader()
                self?.configureTable()
                self?.tableView.reloadData()
            }
        }
    }
    
    private let searchController: UISearchController = {
           let controller = UISearchController(searchResultsController: SearchResultsViewController())
           controller.searchBar.placeholder = "Search movies by title/actor/genre/director"
        controller.searchBar.searchBarStyle = .minimal
           return controller
    }()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(DropDownCell.self, forCellReuseIdentifier: DropDownCell.identifer)
        tableView.register(MovieTile.self, forCellReuseIdentifier: MovieTile.identifier)
        return tableView
    }()
    
    private var tableSection: [TableSectionModel] = []
    
    private var movieDictionary: [String: [String: [Movie]]] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - Private methods
extension MovieViewController {
    private func setupUI() {
        view.backgroundColor = .white
        viewModel.delegate = self
        
        navigationItem.title = MovieViewModel.title
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
    }
    
    private func configureHeader() {
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.identifier )
    }
    
    private func configureTable() {
        configureMovieByYear()
        configureMovieByGenre()
        configureMovieByDirectors()
        configureMovieByActors()
        configureMovieByMovies()
    }
    
    // MARK: - filters
    private func configureMovieByYear() {
        var moviesByYear: [String: [Movie]] = [:]
        
        movies?.sorted(by: {
            $0.year < $1.year
        }).forEach({
            if moviesByYear[$0.year] != nil {
                moviesByYear[$0.year]?.append($0)
            } else {
                moviesByYear[$0.year] = []
                moviesByYear[$0.year]?.append($0)
            }
        })
        
        var labelTitles: [TableSectionModel.TableItemType] = []
        
        for movieYear in moviesByYear.keys {
            labelTitles.append(.titleLabel(movieYear))
        }
        
        tableSection.append(TableSectionModel(sectionType: .Year, itemType: labelTitles, opened: false))
        
        movieDictionary["Year"] = moviesByYear
    }
    
    private func configureMovieByGenre() {
        var moviesByGenre: [String: [Movie]] = [:]
        movies?.sorted(by: {
            $0.genre < $1.genre
        }).forEach({ movie in
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
        
        var labelTitles: [TableSectionModel.TableItemType] = []
        for movieGenre in moviesByGenre.keys {
            labelTitles.append(.titleLabel(movieGenre))
        }
        
        tableSection.append(TableSectionModel(sectionType: .Genre, itemType: labelTitles, opened: false))
        movieDictionary["Genre"] = moviesByGenre
    }
    
    private func configureMovieByDirectors() {
        var moviesByDirector: [String: [Movie]] = [:]
        movies?.sorted(by: {
            $0.director < $1.director
        }).forEach({ movie in
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
        
        var labelTitles: [TableSectionModel.TableItemType] = []
        for movieDirector in moviesByDirector.keys {
            labelTitles.append(.titleLabel(movieDirector))
        }
        
        tableSection.append(TableSectionModel(sectionType: .Directors, itemType: labelTitles, opened: false))
        
        movieDictionary["Director"] = moviesByDirector
    }
    
    private func configureMovieByActors() {
        var moviesByActor: [String: [Movie]] = [:]
        movies?.sorted(by: {
            $0.actors < $1.actors
        }).forEach({ movie in
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
        
        var labelTitles: [TableSectionModel.TableItemType] = []
        for movieActor in moviesByActor.keys {
            labelTitles.append(.titleLabel(movieActor))
        }
        
        tableSection.append(TableSectionModel(sectionType: .Actors, itemType: labelTitles, opened: false))
        
        movieDictionary["Actor"] = moviesByActor
    }
    
    private func configureMovieByMovies() {
        var allMovies: [String: [Movie]] = [:]
        var labelTitles: [TableSectionModel.TableItemType] = []
        movies?.sorted(by: {
            $0.title < $1.title
        }).forEach({
            labelTitles.append(.movie($0))
            if allMovies[$0.title] != nil {
                allMovies[$0.title]?.append($0)
            } else {
                allMovies[$0.title] = []
                allMovies[$0.title]?.append($0)
            }
        })
        
        tableSection.append(TableSectionModel(sectionType: .AllMovies, itemType: labelTitles, opened: false))
        movieDictionary["AllMovies"] = allMovies
    }

}


// MARK: - MovieViewModelDelegate
extension MovieViewController: MovieViewModelDelegate {
    func updateMovieData(movies: [Movie]) {
        self.movies = movies
    }
}


// MARK: - UISearchResultsUpdating
extension MovieViewController: UISearchResultsUpdating, SearchViewControllerDeleagte {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count > 1,
              let resultController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        resultController.delegate = self
        
        let filteredMovies = movies?.filter({
            return $0.title.localizedCaseInsensitiveContains(query) ||
            $0.actors.localizedCaseInsensitiveContains(query) ||
            $0.genre.localizedCaseInsensitiveContains(query) ||
            $0.director.localizedCaseInsensitiveContains(query)
        })
        
        if let filteredMovies = filteredMovies {
            resultController.configure(movies: filteredMovies)
        }
    }
    
    func movieTileSelected(movie: Movie) {
        let previewController = MoviePreviewController()
        previewController.configure(movie: movie)
        navigationController?.pushViewController(previewController, animated: true)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        tableSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableSection[section].opened {
            return tableSection[section].itemType.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSection = tableSection[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView
        
        let title = viewModel.sections[section]
        header?.configure(title: title)
        header?.sectionModel = headerSection
        header?.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = tableSection[indexPath.section]
        switch section.sectionType {
        case .Year, .Genre, .Directors, .Actors:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.identifer, for: indexPath) as? DropDownCell else {
                return UITableViewCell()
            }
            
            for itemType in section.itemType {
                if itemType == section.itemType[indexPath.row] {
                    switch itemType {
                    case .titleLabel(let title):
                        cell.configure(title: title)
                    default:
                        break
                    }
                }
            }
            return cell
            
        case .AllMovies:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTile.identifier, for: indexPath) as? MovieTile else {
                return UITableViewCell()
            }
            
            for itemType in section.itemType {
                if itemType == section.itemType[indexPath.row] {
                    switch itemType {
                    case .movie(let movie):
                        cell.configure(movie: movie)
                    default:
                        break
                    }
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = tableSection[indexPath.section]
        switch section.sectionType {
        case .Year, .Genre, .Directors, .Actors:
            return 50.0
        case .AllMovies:
            return 150.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = tableSection[indexPath.section]
        let filtermoviesViewController = FilteredMoviesViewController()
        if let cell = tableView.cellForRow(at: indexPath) as? DropDownCell {
            
            switch section.sectionType {
            case .Year:
                if let moviesByYear = movieDictionary["Year"],
                   let labelText = cell.currentLabelString(),
                   let movies = moviesByYear[labelText] {
                    filtermoviesViewController.configure(movies: movies)
                    navigationController?.pushViewController(filtermoviesViewController, animated: true)
                }
                
            case .Genre:
                if let moviesByGenre = movieDictionary["Genre"],
                   let labelText = cell.currentLabelString(),
                   let movies = moviesByGenre[labelText] {
                    filtermoviesViewController.configure(movies: movies)
                    navigationController?.pushViewController(filtermoviesViewController, animated: true)
                }
            case .Directors:
                if let moviesByDirector = movieDictionary["Director"],
                   let labelText = cell.currentLabelString(),
                   let movies = moviesByDirector[labelText] {
                    filtermoviesViewController.configure(movies: movies)
                    navigationController?.pushViewController(filtermoviesViewController, animated: true)
                }
            case .Actors:
                if let moviesByActor = movieDictionary["Actor"],
                   let labelText = cell.currentLabelString(),
                   let movies = moviesByActor[labelText] {
                    filtermoviesViewController.configure(movies: movies)
                    navigationController?.pushViewController(filtermoviesViewController, animated: true)
                }
            default:
                break
            }
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? MovieTile {
            switch section.sectionType {
            case .AllMovies:
                if let name = cell.movieName(),
                   let allMovies = movieDictionary["AllMovies"],
                   let movies = allMovies[name] {
                    let previewController = MoviePreviewController()
                    previewController.configure(movie: movies[0])
                    navigationController?.pushViewController(previewController, animated: true)
                }
            default:
                break
            }
        }
    }
}

// MARK: - HeaderViewDelegate
extension MovieViewController: HeaderViewDelegate {
    func buttonTapped(sectionModel: TableSectionModel) {
        tableSection.forEach({ model in
            if model === sectionModel {
                model.opened.toggle()
            }
        })
        tableView.reloadData()
    }
}

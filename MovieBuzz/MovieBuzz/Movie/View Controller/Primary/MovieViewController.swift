//
//  ViewController.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 30/08/23.
//

import UIKit

class MovieViewController: UIViewController {
    enum Constants {
        static let title = "Movie Database"
        static let searchBarPlaceholderText = "Search movies by title/actor/genre/director"
        
        // Table view attributes
        static let heightForHeaderInSection = 50.0
    }
    
    private let searchController: UISearchController = {
           let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = Constants.searchBarPlaceholderText
        controller.searchBar.searchBarStyle = .minimal
           return controller
    }()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        tableView.register(DropDownCell.self, forCellReuseIdentifier: DropDownCell.identifer)
        tableView.register(MovieTile.self, forCellReuseIdentifier: MovieTile.identifier)
        return tableView
    }()
    
    private let viewModel: MovieViewModel = {
       let viewModel = MovieViewModel()
        return viewModel
    }()
    
    private var searchResultViewModel: SearchResultViewModel? = nil
    var sectionHandlers: [SectionHandler] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureViewModel()
        configureSearchResultViewController()
        configureSectionHandler()
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
        
        navigationItem.title = Constants.title
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    private func configureViewModel() {
        viewModel.updateMovies = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.fetchMovieData()
    }
    
    private func configureSearchResultViewController() {
        searchResultViewModel = SearchResultViewModel(coordinator: self)
    }
    
    /**
     * Configure the section handlers for different sections in the table view.
     * Creates instances of section handlers for year, genre, director, actor, and all movies sections,
     * and adds them to the `sectionHandlers` array.
     */
    private func configureSectionHandler() {
        let yearSectionHandler = YearSectionHandler()
        let genreSectionHandler = GenreSectionHandler()
        let directorSectionHandler = DirectorSectionHandler()
        let actorSectionHandler = ActorSectionHandler()
        let allMoviesSectionHandler = AllMoviesSectionHandler()
        
        let sections: [SectionHandler] = [yearSectionHandler, genreSectionHandler, directorSectionHandler, actorSectionHandler, allMoviesSectionHandler]
        
        sections.forEach({
            sectionHandlers.append($0)
        })
    }
}



// MARK: - UISearchResultsUpdating
extension MovieViewController: UISearchResultsUpdating, SearchViewControllerDeleagte, MovieSelectionCoordinator {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let query = searchBar.text
        
        viewModel.updateSearchResults(query: query) { [weak self] filteredMovies in
            guard let strongSelf = self else { return }
            if let resultController = searchController.searchResultsController as? SearchResultsViewController {
                resultController.delegate = strongSelf
                resultController.configure(movies: filteredMovies)
            }
        }
    }
    
    func movieTileSelected(movie: MovieModel) {
        searchResultViewModel?.movieTileSelected(movie: movie)
    }
    
    func showMoviePreview(for movie: MovieModel) {
        let previewController = MoviePreviewController()
        previewController.configure(movie: movie)
        navigationController?.pushViewController(previewController, animated: true)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSection = viewModel.sectionData[section]
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView
        
        let title = SectionType.allCases[section].rawValue
        header?.configure(title: title)
        header?.sectionModel = headerSection
        header?.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.heightForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sectionHandlers[indexPath.section].heightForCell()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sectionData[indexPath.section]
        
        sectionHandlers[indexPath.section].itemType = section.itemType[indexPath.row]
        
        return sectionHandlers[indexPath.section].configureCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = viewModel.sectionData[indexPath.section]
        let selectedItemType = section.itemType[indexPath.row]
        sectionHandlers[indexPath.section].itemType = selectedItemType
        guard let movieData = viewModel.categoryMovieData[SectionType.allCases[indexPath.section]] else {
            return
        }
        
        sectionHandlers[indexPath.section].moviesData = movieData
        sectionHandlers[indexPath.section].didSelectRow(self, at: indexPath)
    }
}

// MARK: - HeaderViewDelegate
extension MovieViewController: HeaderViewDelegate {
    func buttonTapped(sectionModel: SectionModel) {
        viewModel.sectionData.forEach({ model in
            if model === sectionModel {
                model.opened.toggle()
            }
        })
        viewModel.updateMovies()
    }
}

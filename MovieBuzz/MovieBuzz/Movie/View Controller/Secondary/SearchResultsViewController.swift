//
//  SearchResultsViewController.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 30/08/23.
//

import UIKit

protocol SearchViewControllerDeleagte: AnyObject {
    func movieTileSelected(movie: MovieModel)
}

class SearchResultsViewController: UIViewController {
    enum Constant {
        static let cellHeight = 200.0
        static let numberOfSection = 1
    }
    
    weak var delegate: SearchViewControllerDeleagte?

    private var movies: [MovieModel]? = nil {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.searchTableView.reloadData()
            }
        }
    }
    
    private let searchTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(MovieTile.self, forCellReuseIdentifier: MovieTile.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }
}

// MARK: - Private methods
extension SearchResultsViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(searchTableView)
        searchTableView.dataSource = self
        searchTableView.delegate = self
    }
}

// MARK: - Public methods
extension SearchResultsViewController {
    /**
     * Configure the MovieTile view with movie data.
     *
     * - Parameter movie: The movie data to display.
     */
    public func configure(movies: [MovieModel]) {
        self.movies = movies
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        Constant.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTile.identifier, for: indexPath) as? MovieTile else {
            return UITableViewCell()
        }
        
        guard let movie = movies?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(movie: movie)
        
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = movies?[indexPath.row] else {
            return
        }
        delegate?.movieTileSelected(movie: movie)
    }
}

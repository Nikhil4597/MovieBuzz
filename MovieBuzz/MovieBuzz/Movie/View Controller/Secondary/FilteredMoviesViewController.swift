//
//  FilteredMoviesViewController.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 31/08/23.
//

import UIKit

class FilteredMoviesViewController: UIViewController {
    private var movies: [Movie]? = nil {
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTile.self, forCellReuseIdentifier: MovieTile.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - Public methods
extension FilteredMoviesViewController {
    public func configure(movies: [Movie]){
        self.movies = movies
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FilteredMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = movies?[indexPath.row] else {
            return
        }
        
        let movieDetail = MoviePreviewController()
        movieDetail.configure(movie: movie)
        navigationController?.pushViewController(movieDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}

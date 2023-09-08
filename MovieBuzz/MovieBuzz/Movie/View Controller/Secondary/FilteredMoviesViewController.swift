//
//  FilteredMoviesViewController.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 31/08/23.
//

import UIKit

class FilteredMoviesViewController: UIViewController {
    enum Constants {
        static let numberOfSections = 1
        static let cellHeight = 150.0
    }
    
    private var movies: [MovieModel]? = nil {
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private let segmantedControl: UISegmentedControl = {
        let view = UISegmentedControl()
        view.layer.cornerRadius = 5.0
        view.backgroundColor = .white
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieTile.self, forCellReuseIdentifier: MovieTile.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI constraints
    private func setupUIConstraints() {
        let space = 10.0
        let topSpacing = 100.0
        
        /// Sagmentted View constrainsts
        NSLayoutConstraint.activate([
            segmantedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmantedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmantedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpacing),
            segmantedControl.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        /// Table view constraints
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: segmantedControl.bottomAnchor, constant: space),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Private methods
extension FilteredMoviesViewController {
    private func setupUI() {
        view.addSubview(tableView)
        
        setupSegmentedView()
        tableView.dataSource = self
        tableView.delegate = self
        
        setupUIConstraints()
    }
    
    /**
     * Configure the segmented control with sorting options.
     * Inserts sorting options into the segmented control and adds it to the view.
     */
    private func setupSegmentedView() {
        let items = ["Acending", "Decednig", "Sort by Year"]
        for (index, item) in items.enumerated() {
            segmantedControl.insertSegment(withTitle: item, at: index, animated: true)
        }
        
        view.addSubview(segmantedControl)
        segmantedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
    }
    
    /**
     * Handle the change in the selected segment of the segmented control.
     * Sorts the movie data based on the selected sorting option and reloads the table view.
     *
     * - Parameter sender: The UISegmentedControl triggering the action.
     */
    @objc private func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            movies = movies?.sorted(by: { $0 < $1})
        case 1:
            movies = movies?.sorted(by: {$0 > $1})
        case 2:
            movies = movies?.sorted(by: { $0.year < $1.year})
        default:
            break
        }
        
        tableView.reloadData()
    }
}

// MARK: - Public methods
extension FilteredMoviesViewController {
    /**
     * Configure the MovieTile view with movie data.
     *
     * - Parameter movie: The movie data to display.
     */
    public func configure(movies: [MovieModel]){
        self.movies = movies
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FilteredMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        Constants.numberOfSections
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
        Constants.cellHeight
    }
}

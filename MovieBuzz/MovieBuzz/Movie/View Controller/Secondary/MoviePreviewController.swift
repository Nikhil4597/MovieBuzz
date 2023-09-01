//
//  MoviePreviewController.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 30/08/23.
//

import UIKit

class MoviePreviewController: UIViewController {
    struct Constant {
        static let liteLeadingConstraint = 5.0
        static let leadingConstraint = 10.0
        static let spaceConstraint = 15.0
        
        static let releasedDatePrefix = "Release Date: "
        static let genrePrefix = "Genre: "
        static let viewRatingTitle = "View Rating"
    }

    private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let containerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DefaultImage")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releasedDateLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moviePlotLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieGenreLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingButton: UIButton = {
       let button = UIButton()
        button.setTitle("View Rating", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageCache: NSCache<NSString, UIImage> = NSCache()

    private var rating: [Rating]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        scrollView.frame = view.bounds
    }
    
    // MARK: UI view constraints
    private func setupUIConstraints() {
        // Scroll veiw constraints
//        NSLayoutConstraint.activate([
//            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constant.liteLeadingConstraint),
//            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constant.liteLeadingConstraint),
//            containerView.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor),
//            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
//        ])
        
        // Poster image view constraints
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constant.leadingConstraint),
            posterImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constant.leadingConstraint),
            posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            posterImageView.heightAnchor.constraint(equalToConstant: 300),
            posterImageView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        // Movie title constraints
        NSLayoutConstraint.activate([
            movieTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constant.leadingConstraint),
            movieTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constant.leadingConstraint),
            movieTitleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: Constant.spaceConstraint),
            movieTitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
            
        ])
        
        // Movie plot constraints
        NSLayoutConstraint.activate([
            moviePlotLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constant.leadingConstraint),
            moviePlotLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constant.leadingConstraint),
            moviePlotLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: Constant.spaceConstraint),
            moviePlotLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        // Release data constraints
        NSLayoutConstraint.activate([
            releasedDateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constant.leadingConstraint),
            releasedDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constant.leadingConstraint),
            releasedDateLabel.topAnchor.constraint(equalTo: moviePlotLabel.bottomAnchor, constant: Constant.spaceConstraint),
        ])
        
        // Movie genre constrints
        NSLayoutConstraint.activate([
            movieGenreLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constant.leadingConstraint),
            movieGenreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constant.leadingConstraint),
            movieGenreLabel.topAnchor.constraint(equalTo: releasedDateLabel.bottomAnchor, constant: Constant.spaceConstraint)
        ])
        
        // Rating button constraints
        NSLayoutConstraint.activate([
            ratingButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constant.leadingConstraint),
            ratingButton.topAnchor.constraint(equalTo: movieGenreLabel.bottomAnchor, constant: Constant.spaceConstraint),
            ratingButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - Container view constraints
    private func containerViewConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    // MARK: - Scroll view constraints
    private func scrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: Private methods
extension MoviePreviewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerViewConstraints()
        scrollViewConstraints()
        
        let subviews = [posterImageView, movieTitleLabel, moviePlotLabel, releasedDateLabel,  movieGenreLabel]
        
        subviews.forEach({
            containerView.addSubview($0)
        })
        
        view.addSubview(ratingButton)
        ratingButtonAction()

        setupUIConstraints()
    }
    
    private func ratingButtonAction() {
        ratingButton.addTarget(self, action: #selector(viewRatingClicked), for: .touchUpInside)
    }
    
    private func configureImage(imageString: String) {
        guard let url = URL(string: imageString) else {
                  return
              }

              if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                  posterImageView.image = cachedImage
                  return
              }
                  let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                      guard let data = data,
                            let strongSelf = self,
                            let image = UIImage(data: data) else {
                          return
                      }

                      DispatchQueue.global().async {
                          strongSelf.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                      }
                      
                      DispatchQueue.main.async {
                          strongSelf.posterImageView.image = image
                      }
                  }
              task.resume()
    }
    
    private func configure(movieTitle: String, moviePlot: String, releasedDate: String, movieGenre: String) {
        movieTitleLabel.text = movieTitle
        moviePlotLabel.text = moviePlot
        releasedDateLabel.text = "\(Constant.releasedDatePrefix) \(releasedDate)"
        movieGenreLabel.text = "\(Constant.genrePrefix) \(movieGenre)"
    }
    
    @objc private func viewRatingClicked() {
        var message = ""
        guard let rating = rating else {
            return
        }
        
        rating.forEach({
            let value = " \($0.source): \($0.value) \n"
            message += value
        })
        
        let alertController = UIAlertController(title: Constant.viewRatingTitle, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: Public methods
extension MoviePreviewController {
    public func configure(movie: Movie) {
        configureImage(imageString: movie.poster)
        configure(movieTitle: movie.title, moviePlot: movie.plot, releasedDate: movie.released, movieGenre: movie.genre)
        rating = movie.rating
    }
}

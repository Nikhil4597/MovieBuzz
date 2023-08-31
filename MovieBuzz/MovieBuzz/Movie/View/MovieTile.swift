//
//  MovieTile.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 30/08/23.
//

import UIKit

class MovieTile: UITableViewCell {
    static let identifier = "MovieTile"

    struct Constant {
        static let leadingConstraint = 10.0
        static let topConstraint = 10.0
        static let languagePrefix = "Language: "
        static let yearPrefix = "Year: "
    }

    private let thumbnailView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let imageCache: NSCache<NSString, UIImage> = NSCache()
    
    private let movieTitle: UILabel = {
       let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
         label.text = ""
         label.numberOfLines = 0
         label.textColor = .black
         label.textAlignment = .left
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
         label.text = ""
         label.textColor = .black
         label.textAlignment = .left
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let subviews = [thumbnailView, movieTitle, languageLabel, yearLabel]
        
        subviews.forEach({
            contentView.addSubview($0)
        })
        
        setupUIConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
    }
    
    // MARK: -  UI view constraints
    private func setupUIConstraints() {
        // Thumbnail image constraints
        NSLayoutConstraint.activate([
            thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            thumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            thumbnailView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // Movie title constraints
        NSLayoutConstraint.activate([
            movieTitle.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: Constant.leadingConstraint),
            movieTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.leadingConstraint),
            movieTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.topConstraint)
        ])
        
        // Language label constraints
        NSLayoutConstraint.activate([
            languageLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: Constant.leadingConstraint),
            languageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.leadingConstraint),
            languageLabel.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: Constant.topConstraint)
        ])
        
        // Year label constraints
        NSLayoutConstraint.activate([
            yearLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: Constant.leadingConstraint),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.leadingConstraint),
            yearLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: Constant.topConstraint)
        ])
    }
}

// MARK: - Private methods
extension MovieTile {
    private func configureImage(imageString: String) {
        guard let url = URL(string: imageString) else {
                  return
              }

              if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                  thumbnailView.image = cachedImage
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
                          strongSelf.thumbnailView.image = image
                      }
                  }
              task.resume()
    }
    
    private func configureLabels(title: String, language: String, year: String) {
        movieTitle.text = title
        languageLabel.text = "\(Constant.languagePrefix) \(language)"
        yearLabel.text = "\(Constant.yearPrefix) \(year)"
    }
}

// MARK: - Public methods
extension MovieTile {
    public func configure(movie: Movie) {
        configureImage(imageString: movie.poster)
        configureLabels(title: movie.title, language: movie.language, year: movie.year)
    }
    
    public func movieName()  -> String? {
        return movieTitle.text
    }
}

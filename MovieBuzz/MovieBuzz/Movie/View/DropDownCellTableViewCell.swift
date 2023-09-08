//
//  DropDownCellTableViewCell.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 31/08/23.
//

import UIKit

class DropDownCell: UITableViewCell {
    static let identifer = "DropDownCell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        setupUIConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUIConstraints()
    }
    
    // MARK: - UI contraints
    private func setupUIConstraints() {
        /// Title label constaints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 10)
        ])
    }
}

// MARK: - Public methods
extension DropDownCell {
    /**
     * Configure the MovieTile view with movie title.
     *
     * - Parameter title: The movie title to display.
     */
    public func configure(title: String) {
        titleLabel.text = title
    }
    
    /**
     * Retrieve the name of the movie displayed in the MovieTile.
     *
     * - Returns: The name of the movie or nil if not available.
     */
    public func currentLabelString() -> String? {
        return titleLabel.text
    }
}

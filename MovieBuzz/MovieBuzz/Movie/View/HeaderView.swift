//
//  HeaderView.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 31/08/23.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func buttonTapped(sectionModel: SectionModel)
}

class HeaderView: UITableViewHeaderFooterView {
    static let identifier = "HeaderView"
    struct Constant {
        static let leadingConstraint = 10.0
        static let topConstraint = 10.0
        
        // Image name
        static let arrowUp = "chevron.up"
        static let arrowDown = "chevron.down"
    }
    
    public var sectionModel: SectionModel? {
        didSet {
            if let opened = sectionModel?.opened,
               opened == true {
                collapseImageView.image = UIImage(systemName: Constant.arrowUp)
            } else{
                collapseImageView.image = UIImage(systemName: Constant.arrowDown)
            }
        }
    }
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.titleLabel?.textAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let collapseImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: Constant.arrowUp)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    weak var delegate: HeaderViewDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let subviews = [button, collapseImageView]

        subviews.forEach({
            addSubview($0)
        })
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        setupUIConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    // MARK: - UI view constraints
    private func setupUIConstraints() {
        /// label constraints
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: Constant.topConstraint),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.topConstraint),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.leadingConstraint),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        /// button constraints
        NSLayoutConstraint.activate([
            collapseImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constant.topConstraint),
            collapseImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.topConstraint),
            collapseImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.leadingConstraint),
            collapseImageView.widthAnchor.constraint(equalToConstant: 100)
            
        ])
    }
}

// MARK: - Private methods
extension HeaderView {
    @objc private func buttonClicked() {
        if let sectionModel = sectionModel{
            delegate?.buttonTapped(sectionModel: sectionModel)
        }
    }
}

// MARK: - Public methods
extension HeaderView {
    /**
     * Configure the MovieTile view with movie title.
     *
     * - Parameter movie: The movie title to display.
     */
    public func configure(title: String) {
        button.setTitle(title, for: .normal)
    }
}

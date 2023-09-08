//
//  ConfigureCell.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 08/09/23.
//

import UIKit

protocol SectionHandler {
    var itemType: ItemType? {get set}
    var moviesData: [String: [MovieModel]] {get set}
    func heightForCell() -> CGFloat
    func configureCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func didSelectRow(_ viewController: UIViewController, at indexPath: IndexPath)
}

// MARK: - Year section handler class

class YearSectionHandler: SectionHandler {
    var itemType: ItemType? = nil
    var moviesData: [String : [MovieModel]] = [:]
    
    /**
     * Get the height for the cell in this section.
     *
     * - Returns: The height for the cell.
     */
    func heightForCell() -> CGFloat {
        50.0
    }
    
    /**
     * Configure and return a cell for this section.
     *
     * - Parameters:
     *   - tableView: The table view containing the cell.
     *   - indexPath: The index path of the cell.
     * - Returns: A configured table view cell.
     */
    func configureCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.identifer, for: indexPath) as? DropDownCell else {
            return UITableViewCell()
        }
        
        switch itemType {
        case .titleLabel(let title):
            cell.configure(title: title)
        default:
            break
        }
        return cell
    }
    
    /**
     * Handle the selection of a row in this section.
     *
     * - Parameters:
     *   - viewController: The view controller where the action occurs.
     *   - indexPath: The index path of the selected row.
     */
    func didSelectRow(_ viewController: UIViewController, at indexPath: IndexPath) {
        switch itemType {
        case .titleLabel(let title):
            guard let movies = moviesData[title] else {return}
            let filtermoviesViewController = FilteredMoviesViewController()
            filtermoviesViewController.configure(movies: movies)
            viewController.navigationController?.pushViewController(filtermoviesViewController, animated: true)

        default:
            break
        }
    }
}

// MARK: - Genre section handler class

class GenreSectionHandler: SectionHandler {
    var itemType: ItemType? = nil
    var moviesData: [String : [MovieModel]] = [:]
    
    /**
     * Get the height for the cell in this section.
     *
     * - Returns: The height for the cell.
     */
    func heightForCell() -> CGFloat {
        50.0
    }
    
    /**
     * Configure and return a cell for this section.
     *
     * - Parameters:
     *   - tableView: The table view containing the cell.
     *   - indexPath: The index path of the cell.
     * - Returns: A configured table view cell.
     */
    
    func configureCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.identifer, for: indexPath) as? DropDownCell else {
            return UITableViewCell()
        }
        
        switch itemType {
        case .titleLabel(let title):
            cell.configure(title: title)
        default:
            break
        }
        return cell
    }
    
    /**
     * Handle the selection of a row in this section.
     *
     * - Parameters:
     *   - viewController: The view controller where the action occurs.
     *   - indexPath: The index path of the selected row.
     */
    func didSelectRow(_ viewController: UIViewController, at indexPath: IndexPath) {
        switch itemType {
        case .titleLabel(let title):
            guard let movies = moviesData[title] else {return}
            let filtermoviesViewController = FilteredMoviesViewController()
            filtermoviesViewController.configure(movies: movies)
            viewController.navigationController?.pushViewController(filtermoviesViewController, animated: true)
            
        default:
            break
        }
    }
}

// MARK: - Director section handler class

class DirectorSectionHandler: SectionHandler {
    var itemType: ItemType? = nil
    var moviesData: [String : [MovieModel]] = [:]
    
    /**
     * Get the height for the cell in this section.
     *
     * - Returns: The height for the cell.
     */
    func heightForCell() -> CGFloat {
        50.0
    }
    
    /**
     * Configure and return a cell for this section.
     *
     * - Parameters:
     *   - tableView: The table view containing the cell.
     *   - indexPath: The index path of the cell.
     * - Returns: A configured table view cell.
     */
    func configureCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.identifer, for: indexPath) as? DropDownCell else {
            return UITableViewCell()
        }
        
        switch itemType {
        case .titleLabel(let title):
            cell.configure(title: title)
        default:
            break
        }
        return cell
    }
    
    
    /**
     * Handle the selection of a row in this section.
     *
     * - Parameters:
     *   - viewController: The view controller where the action occurs.
     *   - indexPath: The index path of the selected row.
     */
    func didSelectRow(_ viewController: UIViewController, at indexPath: IndexPath) {
        switch itemType {
        case .titleLabel(let title):
            guard let movies = moviesData[title] else {return}
            let filtermoviesViewController = FilteredMoviesViewController()
            filtermoviesViewController.configure(movies: movies)
            viewController.navigationController?.pushViewController(filtermoviesViewController, animated: true)
        default:
            break
        }
    }
}

// MARK: - section handler class

class ActorSectionHandler: SectionHandler {
    var itemType: ItemType? = nil
    var moviesData: [String : [MovieModel]] = [:]
    
    /**
     * Get the height for the cell in this section.
     *
     * - Returns: The height for the cell.
     */
    func heightForCell() -> CGFloat {
        50.0
    }
    
    /**
     * Configure and return a cell for this section.
     *
     * - Parameters:
     *   - tableView: The table view containing the cell.
     *   - indexPath: The index path of the cell.
     * - Returns: A configured table view cell.
     */
    func configureCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropDownCell.identifer, for: indexPath) as? DropDownCell else {
            return UITableViewCell()
        }
        
        switch itemType {
        case .titleLabel(let title):
            cell.configure(title: title)
        default:
            break
        }
        return cell
    }
    
    /**
     * Handle the selection of a row in this section.
     *
     * - Parameters:
     *   - viewController: The view controller where the action occurs.
     *   - indexPath: The index path of the selected row.
     */
    func didSelectRow(_ viewController: UIViewController, at indexPath: IndexPath) {
        switch itemType {
        case .titleLabel(let title):
            guard let movies = moviesData[title] else {return}
            let filtermoviesViewController = FilteredMoviesViewController()
            filtermoviesViewController.configure(movies: movies)
            viewController.navigationController?.pushViewController(filtermoviesViewController, animated: true)
        default:
            break
        }
    }
}

// MARK: - All movies section handler class

class AllMoviesSectionHandler: SectionHandler {
    var itemType: ItemType? = nil
    var moviesData: [String : [MovieModel]] = [:]
    
    /**
     * Get the height for the cell in this section.
     *
     * - Returns: The height for the cell.
     */
    func heightForCell() -> CGFloat {
        150.0
    }
    
    /**
     * Configure and return a cell for this section.
     *
     * - Parameters:
     *   - tableView: The table view containing the cell.
     *   - indexPath: The index path of the cell.
     * - Returns: A configured table view cell.
     */
    func configureCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTile.identifier, for: indexPath) as? MovieTile else {
            return UITableViewCell()
        }
        
        switch itemType {
        case .movie(let movie):
            cell.configure(movie: movie)
        default:
            break
        }
        return cell
    }
    
    /**
     * Handle the selection of a row in this section.
     *
     * - Parameters:
     *   - viewController: The view controller where the action occurs.
     *   - indexPath: The index path of the selected row.
     */
    func didSelectRow(_ viewController: UIViewController, at indexPath: IndexPath) {
        switch itemType {
        case .movie(let movie):
            let previewController = MoviePreviewController()
            previewController.configure(movie: movie)
            viewController.navigationController?.pushViewController(previewController, animated: true)
        default:
            break
        }
    }
}

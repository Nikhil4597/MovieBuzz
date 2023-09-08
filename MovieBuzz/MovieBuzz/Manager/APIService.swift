//
//  APIService.swift
//  MovieBuzz
//
//  Created by ROHIT MISHRA on 30/08/23.
//

import Foundation

enum APIError: Error {
    case JSONFileInvalid
    case FailedToDecorded
}

final class APIService {
    static let shared = APIService()
    
    private init() {}
}

// MARK: - Public methods
extension APIService {
    /**
     * Fetch movies from a JSON file within the bundle.
     *
     * - Parameter completion: A closure that is called when the data is fetched or an error occurs.
     *                         - Parameter:  A `Result` enum containing either the fetched `[MovieModel]` or an `Error`.
     *
     */
    public func getMovies(completion: @escaping(Result<[MovieModel], Error>) -> Void) {
        guard let bundlePath = Bundle.main.url(forResource: "Movies", withExtension: "json") else {
            completion(.failure(APIError.JSONFileInvalid))
                    return
        }
        
        do {
            let jsonData = try Data(contentsOf: bundlePath)
            let result = try JSONDecoder().decode([MovieModel].self, from: jsonData)
            completion(.success(result))
        } catch {
            completion(.failure(APIError.FailedToDecorded))
        }
    }
}

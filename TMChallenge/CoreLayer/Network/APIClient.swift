//
//  APIClient.swift
//  TMChallenge
//
//  Created by Jose Galindo Martinez on 02/11/21.
//

import Foundation
import Combine

final class APIClient {
    
    typealias Parameters = [String: String]
    
    private var baseURL: URL?
    private var decoder : JSONDecoder!
    
    static let shared : APIClient = APIClient()
    private init() {
        baseURL = URL(string: BasicURLs.baseURL)
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    
    // MARK: - Generic GET
    func get<T: Codable>(endpoint: Endpoint,
                         parameters: Parameters = [:]) -> AnyPublisher<Result<T, APIError>, Never> {
        guard let url = baseURL else {
            return Just(Result.failure(APIError.invalidRequest)).eraseToAnyPublisher()
        }
        let queryURL = url.appendingPathComponent(endpoint.path())
        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        if !parameters.isEmpty {
            components.queryItems = parameters.compactMap {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return URLSession.shared.dataTaskPublisher(for: request)
            .map({ $0.data})
            .decode(type: T.self, decoder: decoder)
            .map({ Result.success($0) })
            .catch({ error -> AnyPublisher<Result<T, APIError>, Never> in
                print("\(error)")
                return Just(Result.failure(APIError.jsonDecodingError)).eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }
}

public enum Endpoint {
    case feeds
    
    func path() -> String {
        switch self {
        case .feeds:
            return "/.json"
        }
    }
}

public enum APIError: Error {
    case noResponse
    case invalidRequest
    case jsonDecodingError
    case networkError(error: Error)
}

//
//  APIClient.swift

import Foundation

final class APIClient {
    static let shared = APIClient()
    private let session: URLSession
    private let baseURL = URL(string: "https://api.themoviedb.org/3")!
    private let apiKey = Secrets.tmdbKey

    init(session: URLSession = .shared) {
        self.session = session
    }

    enum APIError: Error {
        case invalidURL, noData, decodingError(Error), serverError(Int)
    }

    private func makeURL(path: String, queryItems: [URLQueryItem] = []) -> URL? {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        var items = queryItems
        items.append(URLQueryItem(name: "api_key", value: apiKey))
        components?.queryItems = items
        return components?.url
    }

    func fetchPopular(page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = makeURL(path: "movie/popular", queryItems: [URLQueryItem(name: "language", value: "en-US"),
                                                                      URLQueryItem(name: "page", value: "\(page)")]) else {
            completion(.failure(APIError.invalidURL)); return
        }
        fetch(url: url, completion: completion)
    }

    func searchMovies(query: String, page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = makeURL(path: "search/movie", queryItems: [URLQueryItem(name: "query", value: query),
                                                                    URLQueryItem(name: "page", value: "\(page)")]) else {
            completion(.failure(APIError.invalidURL)); return
        }
        fetch(url: url, completion: completion)
    }

    private func fetch(url: URL, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                DispatchQueue.main.async { completion(.failure(APIError.serverError(http.statusCode))) }; return
            }
            guard let data = data else { DispatchQueue.main.async { completion(.failure(APIError.noData)) }; return }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                DispatchQueue.main.async { completion(.success(response.results)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(APIError.decodingError(error))) }
            }
        }
        task.resume()
    }
}

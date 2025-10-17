//
//  API.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//
import Foundation


//Error logger to help debugging
enum APIError: LocalizedError {
    case network(URLError)
    case badStatus(Int)
    case invalidURL
    case decodingFailed
    case noData
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .badStatus(let code):
            return "Bad status code: \(code)"
        case .invalidURL:
            return "Invalid URL"
        case .decodingFailed:
            return "failed to decode server response"
        case .noData:
            return "No data returned"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

//api client with two methods (fetchTrending, fetchDetails)
enum TMDBAPI {

    private static let trendingPrefix = "https://api.themoviedb.org/3/trending/movie/"
    private static let detailsPrefix = "https://api.themoviedb.org/3/movie/"
    private static let apiKey = Config.apiKey
    private static let languageParam  = "language=en-US"
    
    //trending time window defaults to day
    static func fetchTrendingMovies(period: String = "day") async throws -> [Movie] {
        let urlString = "\(trendingPrefix)\(period)?\(languageParam)&api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { throw APIError.invalidURL }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode)
        else { throw APIError.badStatus((response as? HTTPURLResponse)?.statusCode ?? 0) }

        do {
            let decoded = try JSONDecoder().decode(TrendingMovies.self, from: data)
            return decoded.results
        } catch {
            throw APIError.decodingFailed
        }
    }

    static func fetchDetails(id: Int) async throws -> MovieDetails {
        let urlString = "\(detailsPrefix)\(id)?\(languageParam)&api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { throw APIError.invalidURL }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode)
        else { throw APIError.badStatus((response as? HTTPURLResponse)?.statusCode ?? 0) }

        do {
            return try JSONDecoder().decode(MovieDetails.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }
}

    

//
//  MoviesRepository.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//

import Foundation

struct MoviesRepository {
    private let cache: TrendingMoviesCache
    
    init(cache: TrendingMoviesCache) {
        self.cache = cache
    }
    
    //get trending movies from cache if available first and fetch + save to cache if not available
    func getTrendingMovies(period: String = "day") async throws -> [Movie] {
        if let cached = cache.load(period: period) {
            return cached
        }
        
        //if cache is not available we fetch and cache the results
        let movies = try await TMDBAPI.fetchTrendingMovies(period: period)
        cache.save(period: period, movies: movies)
        return movies
    }
    
    func fetchMovieDetails(id: Int) async throws -> MovieDetails {
        let movieDetails = try await TMDBAPI.fetchDetails(id: id)
        return movieDetails
    }
    
    
}

//
//  TrendingMoviesCache.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//

import Foundation

final class MovieListCacheEntry {
    let movies: [Movie]
    let timestamp: TimeInterval
    init(movies: [Movie], timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.movies = movies
        self.timestamp = timestamp
    }
}


final class TrendingMoviesCache {
    
    private let cache = NSCache<NSString, MovieListCacheEntry>()
    private let ttl: TimeInterval = 60 * 60 * 12  // 12 hour expiry time to avoid stale date
    
    func load(period: String = "day") -> [Movie]? {
        let key = NSString(string: "trending_\(period)")
        guard let entry = cache.object(forKey: key) else { return nil }
        // Check expiration
        let now = Date().timeIntervalSince1970
        if now - entry.timestamp > ttl {
            cache.removeObject(forKey: key)
            return nil
        }
        return entry.movies
    }

    func save(period: String = "day", movies: [Movie]) {
        let key = NSString(string: "trending_\(period)")
        let entry = MovieListCacheEntry(movies: movies)
        cache.setObject(entry, forKey: key)
    }
    
}

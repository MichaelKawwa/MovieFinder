//
//  MovieFinderApp.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/16/25.
//

import SwiftUI

@main
struct MovieFinderApp: App {
    
    let movieRepo = MoviesRepository(cache: TrendingMoviesCache())
    let apiKey = Config.apiKey
    
    
    var body: some Scene {
        WindowGroup {
            HomeView(movieRepo: movieRepo)
        }
    }
}

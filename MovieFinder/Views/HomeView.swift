//
//  ContentView.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/16/25.
//

import SwiftUI

struct HomeView: View {
    
    let movieRepo: MoviesRepository
    @StateObject private var favorites = FavoriteMoviesStore()
    
    var body: some View {
        TabView {
               NavigationView {
                   DiscoverView(movieRepo: movieRepo)
               }
               .tabItem { Label("Discover", systemImage: "film.stack") }

               NavigationView {
                   FavoritesView(movieRepo: movieRepo)
               }
               .tabItem { Label("Favorites", systemImage: "heart") }
           }
           .environmentObject(favorites)
        }
}


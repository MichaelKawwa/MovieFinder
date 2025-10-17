//
//  DiscoverView.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//


import SwiftUI

struct DiscoverView: View {
    let movieRepo: MoviesRepository

    @EnvironmentObject private var favorites: FavoriteMoviesStore
    @StateObject private var vm: DiscoverViewModel

    init(movieRepo: MoviesRepository) {
        self.movieRepo = movieRepo
        _vm = StateObject(wrappedValue: DiscoverViewModel(movieRepo: movieRepo))
    }

    var body: some View {
        VStack(spacing: 12) {
            Picker("Trending", selection: $vm.trendingPeriod) {
                Text("Today").tag("day")
                Text("This Week").tag("week")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            content
        }
        .navigationTitle("Trending")
        .task { vm.onAppear() }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle, .loading:
            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let msg):
            ErrorView(message: msg) { Task { await vm.load() } }
        case .loaded(let movies):
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 5) {
                    ForEach(movies) { movie in
                        NavigationLink {
                            DetailsView(id: movie.id, movieRepo: movieRepo)
                        } label: {
                            MovieCard(movie: movie,
                                     isFavorite: favorites.favorites.contains(movie.id),
                                     onHeart: { favorites.toggle(movie.id) })
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}


//
//  FavoritesView.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//

import SwiftUI

struct FavoritesView: View {
    let movieRepo: MoviesRepository

    @EnvironmentObject private var favorites: FavoriteMoviesStore
    @StateObject private var vm: FavoritesViewModel

    init(movieRepo: MoviesRepository) {
        self.movieRepo = movieRepo
        // create once; placeholder favorites gets replaced later
        _vm = StateObject(
            wrappedValue: FavoritesViewModel(
                repo: movieRepo,
                favorites: FavoriteMoviesStore()
            )
        )
    }

    var body: some View {
        List { content }
            .navigationTitle("Favorites")
            .toolbar { EditButton() }
            .onAppear {
                // Rebind favorites inside the same VM instance
                vm.setFavorites(favorites)
                Task { await vm.reload() }
            }
            .onChange(of: favorites.favorites) { _ in
                Task { await vm.reload() }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle, .loading:
            ProgressView().frame(maxWidth: .infinity, alignment: .center)
        case .failed(let msg):
            Text(msg).foregroundStyle(.red)
        case .loaded:
            ForEach(vm.items, id: \.id) { movie in
                NavigationLink {
                    DetailsView(id: movie.id, movieRepo: movieRepo)
                } label: {
                    FavoriteRow(movie: movie,
                                isFavorite: favorites.favorites.contains(movie.id),
                                onHeart: { favorites.toggle(movie.id) })
                }
            }
            .onDelete { idx in
                for i in idx { vm.remove(id: vm.items[i].id) }
                Task { await vm.reload() }
            }
        }
    }
}

private struct FavoriteRow: View {
    let movie: Movie
    let isFavorite: Bool
    let onHeart: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            PosterThumb(url: movie.posterURL)
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title ?? "Untitled")
                    .font(.headline)
                    .lineLimit(2)
                Text("Rating: \(movie.voteAverage!, format: .number)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: onHeart) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
            }
            .buttonStyle(.plain)
        }
    }
}

private struct PosterThumb: View {
    let url: URL?
    var body: some View {
        AsyncImage(url: url) { img in
            img.resizable()
        } placeholder: {
            Color.gray.opacity(0.2)
        }
        .frame(width: 60, height: 90)
        .cornerRadius(6)
        .id(url)
    }
}



//
//  FavoritesViewModel.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//

import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var items: [Movie] = []

    enum State { case idle, loading, loaded(Void), failed(String) }
    @Published private(set) var state: State = .idle

    private let repo: MoviesRepository
    private var favorites: FavoriteMoviesStore   // <- make it var (not let)

    init(repo: MoviesRepository, favorites: FavoriteMoviesStore) {
        self.repo = repo
        self.favorites = favorites
    }

    // NEW: allow re-binding the favorites store after init
    func setFavorites(_ store: FavoriteMoviesStore) {
        self.favorites = store
    }

    func onAppear() { Task { await reload() } }

    func reload() async {
        state = .loading
        do {
            let day  = try await repo.getTrendingMovies(period: "day")
            let week = try await repo.getTrendingMovies(period: "week")

            // Merge day+week by id, keep the first occurrence (or choose your rule)
            let dict = (day + week).reduce(into: [Int: Movie]()) { acc, m in
                acc[m.id] = acc[m.id] ?? m        // keep existing; or replace to prefer `week`
            }

            items = favorites.favorites
                .compactMap { dict[$0] }
                .sorted { ($0.title ?? "") < ($1.title ?? "") }

            state = .loaded(())
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func remove(id: Int) { favorites.toggle(id) }
}

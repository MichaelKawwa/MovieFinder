//
//  FavoritesViewModel.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//

import Foundation

@MainActor
final class DetailsViewModel: ObservableObject {
    
    //track state
    enum State { case loading, loaded(MovieDetails), failed(String) }
    @Published private(set) var state: State = .loading

    private let id: Int
    private let movieRepo: MoviesRepository

    init(id: Int, movieRepo: MoviesRepository) {
        self.id = id
        self.movieRepo = movieRepo
    }
    
    func onAppear() { Task { await load() } }

    //asynchronously fetch movie details
    func load() async {
        do {
            let d = try await movieRepo.fetchMovieDetails(id: id)
            state = .loaded(d)
        } catch {
            state = .failed((error as? LocalizedError)?.errorDescription ?? error.localizedDescription)
        }
    }
}

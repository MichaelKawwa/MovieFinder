//
//  DiscoverViewModel.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//

import Foundation

@MainActor
final class DiscoverViewModel: ObservableObject {
    //track the selected trending time {day, week}
    //update responses when trending time parameter is changed
    @Published var trendingPeriod: String = "day" {
            //aschronously reload when trending period set
            didSet { Task { await load() } }
        }
    
    //keep track of current state
    enum State {
        case idle
        case loading
        case loaded([Movie])
        case failed(String)
    }
    
    @Published private(set) var state: State = .idle

    
    private let movieRepo: MoviesRepository
    
    
    init(movieRepo: MoviesRepository) {
        self.movieRepo = movieRepo
    }
    
    func onAppear() { Task { await load() } }
    
    func load() async {
        state = .loading
        do {
            let movies = try await movieRepo.getTrendingMovies(period: trendingPeriod)
            state = .loaded(movies)
        } catch {
            state = .failed((error as? LocalizedError)?.errorDescription ?? error.localizedDescription)
        }
    }
    
}

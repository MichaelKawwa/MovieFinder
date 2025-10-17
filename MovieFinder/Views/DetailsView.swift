//
//  DetailsView.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//

import SwiftUI

struct DetailsView: View {
    let id: Int
    let movieRepo: MoviesRepository

    @EnvironmentObject private var favorites: FavoriteMoviesStore
    @StateObject private var vm: DetailsViewModel

    init(id: Int, movieRepo: MoviesRepository) {
        self.id = id
        self.movieRepo = movieRepo
        _vm = StateObject(wrappedValue: DetailsViewModel(id: id, movieRepo: movieRepo))
    }

    var body: some View {
        VStack {
            switch vm.state {
            case .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .failed(let msg):
                ErrorView(message: msg) { Task { await vm.load() } }
            case .loaded(let d):
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ZStack(alignment: .topTrailing) {
                            AsyncImage(url: d.posterURL) { phase in
                                switch phase {
                                case .success(let img): img.resizable().scaledToFill()
                                case .empty: Rectangle().opacity(0.1).overlay(ProgressView())
                                case .failure: Image(systemName: "film").resizable().scaledToFit().padding()
                                @unknown default: Color.gray
                                }
                            }
                            .frame(height: 260)
                            .clipped()

                            Button {
                                favorites.toggle(d.id)
                            } label: {
                                Image(systemName: favorites.favorites.contains(d.id) ? "heart.fill" : "heart")
                                    .padding(10)
                                    .background(.ultraThinMaterial, in: Circle())
                            }
                            .padding()
                        }

                        Text(d.title ?? "Untitled")
                            .font(.title).bold()

                        if let tagline = d.tagline, !tagline.isEmpty {
                            Text(tagline).italic().foregroundStyle(.secondary)
                        }

                        HStack(spacing: 12) {
                            if let vote = d.voteAverage {
                                Label(String(format: "%.1f", vote), systemImage: "star.fill")
                                    .foregroundStyle(.yellow)
                            }
                            if let runtime = d.runtime {
                                Label("\(runtime/60)h \(runtime%60)m", systemImage: "clock")
                            }
                            if let date = d.releaseDate {
                                Label(date, systemImage: "calendar")
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                        if let genres = d.genres, !genres.isEmpty {
                            Text(genres.map { $0.name }.joined(separator: " • "))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        if let overview = d.overview, !overview.isEmpty {
                            Text(overview).padding(.top, 4)
                        }

                        Spacer(minLength: 20)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .task { vm.onAppear() }
    }
}

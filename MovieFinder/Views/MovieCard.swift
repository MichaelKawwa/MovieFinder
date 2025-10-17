//
//  MovieCard.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//

import SwiftUI

struct MovieCard: View {
    let movie: Movie
    let isFavorite: Bool
    let onHeart: () -> Void

        var body: some View {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 6) {
                    AsyncImage(url: movie.posterURL) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().scaledToFill()
                        case .empty:
                            Rectangle().opacity(0.1)
                                .overlay(ProgressView())
                        case .failure:
                            Image(systemName: "film")
                                .resizable().scaledToFit().padding()
                        @unknown default:
                            Color.gray
                        }
                    }
                    .frame(width: 160, height: 240)
                    .clipped()
                    Text(movie.title!)
                        .font(.headline)
                        .lineLimit(1)
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                        Text(String(format: "%.1f", movie.voteAverage ?? 0))
                    }
                    .font(.subheadline)
                    .foregroundStyle(.yellow)
                }
                Button(action: onHeart) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding(8)
            }
            .frame(width: 160)
            .shadow(radius: 2)
        }
}



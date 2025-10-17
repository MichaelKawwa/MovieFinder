//
//  FavoriteMoviesStore.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//

import Foundation
import SwiftUI

//class to persist users favorited MovieID's
//the movies id is all we need to store since we can fetch the movie
//Saving using UserDefaults is optimal here for a quick lightweight approach to store a list of id's
//using @AppStorage to autmatically update the view when a movie is saved
final class FavoriteMoviesStore: ObservableObject {
    @AppStorage("favoriteMovies") private var favoriteData: Data = Data() //encode the resulting array to store in UserDefaults
    @Published private(set) var favorites: Set<Int> = [] //actual set of ID's 

       init() { favorites = decode() }

       func isFavorite(_ id: Int) -> Bool { favorites.contains(id) }

       func toggle(_ id: Int) {
           if favorites.contains(id) { favorites.remove(id) } else { favorites.insert(id) }
           persist()
       }

       private func persist() {
           let data = try? JSONEncoder().encode(Array(favorites))
           favoriteData = data ?? Data()
       }
       private func decode() -> Set<Int> {
           guard let array = try? JSONDecoder().decode([Int].self, from: favoriteData) else { return [] }
           return Set(array)
       }
}

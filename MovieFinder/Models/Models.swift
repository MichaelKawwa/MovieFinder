//
//  MovieModel.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//

import Foundation

struct Movie: Identifiable, Codable, Equatable {
    let id: Int
    let title: String?
    let overview: String?
    let posterPath: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
    
    var posterURL: URL? { posterPath.flatMap { Config.imageURLPrefix.appendingPathComponent($0) } } //get posturl from baseurl + post url

}

struct TrendingMovies: Codable {
    let results: [Movie]
}

//cache these details using Codable
struct MovieDetails: Codable {
     let id: Int
     let title: String?
     let overview: String?
     let posterPath: String?
     let releaseDate: String?
     let runtime: Int?
     let voteAverage: Double?
     let genres: [Genre]?
     let adult: Bool?
     let spokenLanguages: [SpokenLanguage]?
     let productionCompanies: [Company]?
     let status: String?
     let tagline: String?
    
     //to make this work with Codable we need to make it conform to the CodingKeys protocol
     enum CodingKeys: String, CodingKey {
         case id, title, overview, runtime, genres, adult, status, tagline
         case posterPath = "poster_path"
         case releaseDate = "release_date"
         case voteAverage = "vote_average"
         case spokenLanguages = "spoken_languages"
         case productionCompanies = "production_companies"
     }
    
    struct Genre: Codable { let id: Int; let name: String }
    struct SpokenLanguage: Codable { let englishName: String?; let iso_639_1: String?; let name: String? }
    struct Company: Codable { let id: Int; let name: String }
    
    var posterURL: URL? { posterPath.flatMap { Config.imageURLPrefix.appendingPathComponent($0) } }

    
}



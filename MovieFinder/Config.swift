//
//  Config.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//

import Foundation

enum Config {
    static var apiKey: String {
        //get api key from info.plist which was was inject from the Config.xcconfig file
        guard let key = Bundle.main.infoDictionary?["api_key"] as? String, !key.isEmpty else {
            fatalError("Missing API Key in Info.plist")
        }
        return key
    }
    //get prefix of image url for movie images
    static let imageURLPrefix = URL(string: "https://image.tmdb.org/t/p/w500")!
}

//
//  helpers.swift
//  MovieFinder
//
//  Created by michael kawwa on 10/17/25.
//

import SwiftUI


struct ErrorView: View {
    let message: String
    var retry: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.exclamationmark").font(.largeTitle)
            Text(message).multilineTextAlignment(.center)
            if let retry { Button("Retry", action: retry) }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}



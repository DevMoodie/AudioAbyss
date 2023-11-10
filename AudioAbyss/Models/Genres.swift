//
//  Genres.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-07.
//

import Foundation

struct RecommendedGenres: Codable {
    let genres: [String]
}

struct Recommendations: Codable {
    let tracks: [AudioTrack]
}

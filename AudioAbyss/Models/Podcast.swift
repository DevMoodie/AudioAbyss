//
//  Show.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-09.
//

import Foundation

struct Show: Codable, Hashable {
    let available_markets: [String]
    let external_urls: [String: String]
    let description: String
    let id: String
    let images: [ImageResponse]
    let name: String
    let publisher: String
    let total_episodes: Int
}

struct Episode: Codable, Hashable {
    let description: String
    let duration_ms: Int
    let external_urls: [String: String]
    let id: String
    let images: [ImageResponse]
    let name: String
}

struct Audiobook: Codable, Hashable {
//    let authors: [Author]
//    let available_markets: [String]
//    let description: String
//    let external_urls: [String: String]
//    let id: String
//    let images: [ImageResponse]
    let name: String
//    let narrators: [Narrator]
//    let publisher: String
//    let total_chapters: Int
}

struct Author: Codable, Hashable {
    let name: String
}

struct Narrator: Codable, Hashable {
    let name: String
}

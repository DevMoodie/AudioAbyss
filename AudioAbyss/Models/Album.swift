//
//  File.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-07.
//

import Foundation

struct Albums: Codable {
    let items: [Album]
}

struct Album: Codable, Hashable {
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [ImageResponse]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
}

struct AlbumDetails: Codable, Hashable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let images: [ImageResponse]
    let label: String
    let name: String
    let tracks: Tracks
}

struct Tracks: Codable, Hashable {
    let items: [AudioTrack]
}

struct NewReleases: Codable {
    let albums: Albums
}

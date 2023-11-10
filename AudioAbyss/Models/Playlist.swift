//
//  Playlist.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import Foundation

struct FeaturedPlaylists: Codable {
    let playlists: Playlists
}

struct Playlists: Codable {
    let items: [Playlist]
}

struct Playlist: Codable, Hashable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [ImageResponse]
    let name: String
    let owner: PlaylistUser
}

struct PlaylistDetails: Codable, Hashable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [ImageResponse]
    let name: String
    let tracks: PlaylistTracks
}

struct PlaylistTracks: Codable, Hashable {
    let items: [PlaylistTrack]
}

struct PlaylistTrack: Codable, Hashable {
    let track: AudioTrack
}

struct PlaylistUser: Codable, Hashable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}

//
//  SearchResult.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-09.
//

import Foundation

struct SearchResultResponse: Codable, Hashable {
    let albums: AlbumResults
    let artists: ArtistResults
    let playlists: PlaylistResults
    let tracks: TrackResults
    let shows: ShowResults
    let episodes: EpisodeResults
//    let audiobooks: AudiobookResults
}

enum SearchResult: Hashable {
    case album(model: Album)
    case artist(model: SearchArtist)
    case playlist(model: Playlist)
    case track(model: AudioTrack)
    case show(model: Show)
    case episode(model: Episode)
//    case audiobook(model: Audiobook)
}


enum SearchResultType: String, CaseIterable {
    case albums = "Albums"
    case artists = "Artists"
    case playlists = "Playlists"
    case tracks = "Tracks"
    case shows = "Shows"
    case episodes = "Episodes"
//    case audiobooks = "AudioBooks
}

struct SearchSection: Hashable {
    let title: String
    let results: [SearchResult]
}

struct AlbumResults: Codable, Hashable {
    let items: [Album]
}

struct ArtistResults: Codable, Hashable {
    let items: [SearchArtist]
}

struct PlaylistResults: Codable, Hashable {
    let items: [Playlist]
}

struct TrackResults: Codable, Hashable {
    let items: [AudioTrack]
}

struct ShowResults: Codable, Hashable {
    let items: [Show]
}

struct EpisodeResults: Codable, Hashable {
    let items: [Episode]
}

struct AudiobookResults: Codable, Hashable {
    let items: [Audiobook]
}

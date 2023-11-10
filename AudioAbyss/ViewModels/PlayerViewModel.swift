//
//  PlayerViewModel.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-10.
//

import Foundation

class PlayerViewModel: ObservableObject {
    @Published var track: AudioTrack?
    @Published var albumImageURL: URL?
    
    init(track: AudioTrack?, albumImageURL: URL? = nil) {
        self.track = track
        self.albumImageURL = albumImageURL
    }
    
    func startPlayback(track: AudioTrack) {
        
    }
    
    func joinArtists(track: AudioTrack) -> String {
        guard let firstArtist = track.artists.first?.name else { return "" }
        var artistsString = firstArtist
        if track.artists.count > 1 {
            artistsString += " ft"
        }
        
        track.artists.forEach { artist in
            if artist != track.artists.first {
                artistsString += ". " + artist.name
            }
        }
        
        return artistsString
    }
    
}

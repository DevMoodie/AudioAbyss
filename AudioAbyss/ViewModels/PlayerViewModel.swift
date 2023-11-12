//
//  PlayerViewModel.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-10.
//

import SwiftUI
import AVFoundation

class PlayerViewModel: ObservableObject {
    @Published var track: AudioTrack?
    @Published var albumImageURL: URL?
    @Published var angle: Double = 0
    
    @Published var isPlaying: Bool = false
    
    var player: AVPlayer?
    
    init(track: AudioTrack?, albumImageURL: URL? = nil) {
        self.track = track
        self.albumImageURL = albumImageURL
        startPlayback(track: track)
    }
    
    func startPlayback(track: AudioTrack?) {
        guard let track = track,
              let url = URL(string: track.preview_url ?? "") else { return }
        player = AVPlayer(url: url)
        player?.volume = 0.5
        self.player?.play()
        self.isPlaying = true
    }
    
    func play() {
        if player?.timeControlStatus == .playing { player?.pause(); isPlaying = false } else { player?.play(); isPlaying = true }
    }
    
    func getCurrentTime(value: TimeInterval) -> String {
        return "\(Int(value / 60)):\(Int(value.truncatingRemainder(dividingBy: 60)) < 9 ? "0" : "")\(Int(value.truncatingRemainder(dividingBy: 60)))"
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

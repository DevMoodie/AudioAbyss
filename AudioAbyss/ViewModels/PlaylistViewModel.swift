//
//  PlaylistViewModel.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-08.
//

import Foundation

class PlaylistViewModel: ObservableObject {
    @Published var playlist: Playlist?
    @Published var playlistDetails: PlaylistDetails?
    
    init(playlist: Playlist) {
        self.playlist = playlist
        fetchPlaylistDetails(with: playlist)
    }
    
    func fetchPlaylistDetails(with playlist: Playlist?) {
        guard let playlist = playlist else { return }
        
        NetworkManager.shared.getPlaylistDetails(for: playlist) { [weak self] result in
            switch result {
            case .success(let playlistDetails):
                DispatchQueue.main.async {
                    self?.playlistDetails = playlistDetails
                }
            case .failure(let error):
                print("Failed to get playlist details: \(error.localizedDescription)")
            }
        }
    }
}

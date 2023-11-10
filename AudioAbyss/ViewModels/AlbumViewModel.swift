//
//  PlaylistViewModel.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-08.
//

import Foundation

class AlbumViewModel: ObservableObject {
    @Published var album: Album?
    @Published var albumDetails: AlbumDetails?
    
    init(album: Album) {
        self.album = album
        fetchAlbumDetails(with: album)
    }
    
    func fetchAlbumDetails(with album: Album?) {
        guard let album = album else { return }
        
        NetworkManager.shared.getAlbumDetails(for: album) { [weak self] result in
            switch result {
            case .success(let albumDetails):
                DispatchQueue.main.async {
                    self?.albumDetails = albumDetails
                }
            case .failure(let error):
                print("Failed to get new releases: \(error.localizedDescription)")
            }
        }
    }
}

//
//  SearchViewModel.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-09.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var categories: [Category]?
    @Published var searchSections: [SearchSection]?
    
    init() {
        fetchCategories()
    }
    
    private func fetchCategories() {
        NetworkManager.shared.getCategories { [weak self] result in
            switch result {
            case .success(let categories):
                DispatchQueue.main.async {
                    self?.categories = categories.categories.items
                }
            case .failure(let error):
                print("Failed to get categories: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchSearchResults(with query: String) {
        NetworkManager.shared.search(with: query.trimmingCharacters(in: .whitespacesAndNewlines)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let searchResults):
                    let tracks = searchResults.filter({
                        switch $0 {
                        case .track: return true
                        default: return false
                        }
                    })
                    let artists = searchResults.filter({
                        switch $0 {
                        case .artist: return true
                        default: return false
                        }
                    })
                    let albums = searchResults.filter({
                        switch $0 {
                        case .album: return true
                        default: return false
                        }
                    })
                    let playlists = searchResults.filter({
                        switch $0 {
                        case .playlist: return true
                        default: return false
                        }
                    })
                    let shows = searchResults.filter({
                        switch $0 {
                        case .show: return true
                        default: return false
                        }
                    })
                    let episodes = searchResults.filter({
                        switch $0 {
                        case .episode: return true
                        default: return false
                        }
                    })
//                        let audiobooks = searchResults.filter({
//                            switch $0 {
//                            case .audiobook: return true
//                            default: return false
//                            }
//                        })
                    
                    self.searchSections = [
                        SearchSection(title: "Tracks", results: tracks),
                        SearchSection(title: "Artists", results: artists),
                        SearchSection(title: "Albums", results: albums),
                        SearchSection(title: "Playlists", results: playlists),
                        SearchSection(title: "Episodes", results: episodes),
                        SearchSection(title: "Shows", results: shows)
//                        SearchSection(title: "AudioBooks", results: audiobooks)
                    ]
                case .failure(let error):
                    print("Could not search: \(error.localizedDescription)")
                }
            }
        }
    }
}

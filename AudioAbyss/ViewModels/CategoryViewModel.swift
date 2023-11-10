//
//  CategoryViewModel.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-09.
//

import Foundation

class CategoryViewModel: ObservableObject {
    @Published var category: Category?
    @Published var playlists: [Playlist]?
    
    init(category: Category?) {
        self.category = category
        fetchCategoryPlaylists(with: category)
    }
    
    func fetchCategoryPlaylists(with category: Category?) {
        guard let category = category else { return }
        
        NetworkManager.shared.getCategoryPlaylists(for: category) { [weak self] result in
            switch result {
            case .success(let playlists):
                DispatchQueue.main.async {
                    self?.playlists = playlists
                }
            case .failure(let error):
                print("Failed to get playlist details: \(error.localizedDescription)")
            }
        }
    }
}

//
//  MainMenuViewModel.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-07.
//

import Foundation

class MainMenuViewModel: ObservableObject {
    
    @Published var newReleases: NewReleases?
    @Published var featuredPlaylists: FeaturedPlaylists?
    @Published var recommendations: Recommendations?
    
    init() {
        fetchNewReleases()
        fetchFeaturedPlaylists()
        fetchRecommendedGenres()
    }
    
    private func fetchNewReleases() {
        NetworkManager.shared.getNewReleases { [weak self] result in
            switch result {
            case .success(let newReleases):
                DispatchQueue.main.async {
                    self?.newReleases = newReleases
                }
            case .failure(let error):
                print("Failed to get new releases: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchFeaturedPlaylists() {
        NetworkManager.shared.getFeaturedPlaylists { [weak self] result in
            switch result {
            case .success(let featuredPlaylists):
                DispatchQueue.main.async {
                    self?.featuredPlaylists = featuredPlaylists
                }
            case .failure(let error):
                print("Failed to get new releases: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchRecommendedGenres() {
        NetworkManager.shared.getRecommendedGenres { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recommendedGenres):
                    let genres = recommendedGenres.genres
                    var seeds = Set<String>()
                    while seeds.count < 5 {
                        if let random = genres.randomElement() {
                            seeds.insert(random)
                        }
                    }
                    
                    NetworkManager.shared.getRecommendations(genres: seeds) { [weak self] result in
                        switch result {
                        case .success(let recommendations):
                            DispatchQueue.main.async {
                                self?.recommendations = recommendations
                            }
                        case .failure(let error):
                            print("Failed to get new releases: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Failed to get new releases: \(error.localizedDescription)")
                }
            }
        }
    }
}

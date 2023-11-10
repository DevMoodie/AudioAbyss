//
//  ProfileViewModle.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-07.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    
    init() {
        fetchProfile()
    }
    
    private func fetchProfile() {
        NetworkManager.shared.getCurrentUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

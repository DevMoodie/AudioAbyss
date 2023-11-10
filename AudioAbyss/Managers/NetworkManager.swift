//
//  APICaller.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import Foundation
import Combine


enum HTTPMethod: String {
    case GET
    case POST
}

enum APIError: Error {
    case invalidData
    case invalidResponse
    case badRequest
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    struct Constants {
        
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    // MARK: - Albums
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetails, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(AlbumDetails.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Get Current User Error: ~ \(error.localizedDescription) ~")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Playlists
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetails, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(PlaylistDetails.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Get Current User Error: ~ \(error.localizedDescription) ~")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Profile
    
    public func getCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(User.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Get Current User Error: ~ \(error.localizedDescription) ~")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Browse
    
    public func getNewReleases(completion: @escaping (Result<NewReleases, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=50"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(NewReleases.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Get Current User Error: ~ \(error.localizedDescription) ~")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylists, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=50"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(FeaturedPlaylists.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Get Current User Error: ~ \(error.localizedDescription) ~")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping (Result<RecommendedGenres, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(RecommendedGenres.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Get Current User Error: ~ \(error.localizedDescription) ~")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping (Result<Recommendations, Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"),
            type: .GET
        ) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Recommendations.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Get Current User Error: ~ \(error.localizedDescription) ~")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else { return }
            
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            
            completion(request)
        }
    }
}

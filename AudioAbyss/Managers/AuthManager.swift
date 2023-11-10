//
//  AuthManager.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    struct Constants {
        static let clientID: String = "325654c6d63d4cefaf1c308fc4373f7e"
        static let clientSecret: String = "7cb7e08d960e423aafdce113b6dac520"
        static let tokenAPIURL: String = "https://accounts.spotify.com/api/token"
        static let authURLBase: String = "https://accounts.spotify.com/authorize"
        static let redirectURI: String = "https://www.deenoverdunya.io"
        static let scopes: String = "user-read-private%20playlist-modify-private%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    private init() {}
    
    public var signInURL: URL? {
        let authURLString = "\(Constants.authURLBase)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: authURLString)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else { return false }
        
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    public func exchangeCodeForToken(code: String) async throws -> Bool {
        // Get Token
        guard let tokenURL = URL(string: Constants.tokenAPIURL) else { return false }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let tokenData = basicToken.data(using: .utf8)
        let base64String = tokenData?.base64EncodedString() ?? ""
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let result = try JSONDecoder().decode(AuthResponse.self, from: data)
            self.cacheToken(result: result)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    // Supplies Valid token to be used with Network API Calls
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            // Refresh
            Task {
                let refresh = try await refreshAccessToken()
                
                if let token = self.accessToken, refresh {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshAccessToken() async throws -> Bool {
        guard !refreshingToken else { return false }
        guard shouldRefreshToken else { return true }
        
        guard let refreshToken = refreshToken else { return false }
        
        guard let tokenURL = URL(string: Constants.tokenAPIURL) else { return false }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let tokenData = basicToken.data(using: .utf8)
        let base64String = tokenData?.base64EncodedString() ?? ""
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        self.refreshingToken = false
        
        do {
            let result = try JSONDecoder().decode(AuthResponse.self, from: data)
            self.onRefreshBlocks.forEach { $0(result.access_token) }
            self.onRefreshBlocks.removeAll()
            self.cacheToken(result: result)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    private func cacheToken(result: AuthResponse) {
        // Caching Access/Refresh Tokens + Token Expiration Date
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}

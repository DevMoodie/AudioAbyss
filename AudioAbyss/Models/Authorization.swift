//
//  AuthResponse.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}

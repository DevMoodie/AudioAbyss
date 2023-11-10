//
//  User.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import Foundation

struct User: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
//    let followers: [String: Int]
    let id: String
    let product: String
    let images: [ImageResponse]
}

//
//  Artist.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import Foundation

struct Artist: Codable, Hashable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}

struct SearchArtist: Codable, Hashable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
    let images: [ImageResponse]
}

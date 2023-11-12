//
//  AudioTrack.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-04.
//

import Foundation

struct AudioTrack: Codable, Hashable {
    let album: Album?
    let artists: [Artist]
    let preview_url: String?
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String
    let name: String
}

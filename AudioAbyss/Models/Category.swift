//
//  Category.swift
//  AudioAbyss
//
//  Created by Moody on 2023-11-09.
//

import Foundation

struct CategoryResponse: Codable, Hashable {
    let categories: Categories
}

struct Categories: Codable, Hashable {
    let items: [Category]
}

struct Category: Codable, Hashable {
    let id: String
    let name: String
    let icons: [ImageResponse]
}

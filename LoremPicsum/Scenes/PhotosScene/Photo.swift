//
//  Photo.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import Foundation

/// Represents response element from https://picsum.photos/v2/list
/// See https://picsum.photos for the details
struct Photo: Codable, Identifiable, Hashable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let downloadUrl: URL
    let format: String?
    let createdAt: String?
    let authorUrl: URL?

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case downloadUrl = "download_url"
        case format
        case createdAt = "created_at"
        case authorUrl = "author_url"

    }
}

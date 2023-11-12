//
//  Photo.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import Foundation

struct Photo: Codable, Identifiable, Hashable {
    let id: String
    let author: String
    let downloadUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case downloadUrl = "download_url"
    }
}

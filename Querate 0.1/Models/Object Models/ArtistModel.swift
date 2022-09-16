//
//  ArtistModel.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/22/22.
//

import Foundation

struct ArtistModel: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
    let images: [ImageModel]?
}

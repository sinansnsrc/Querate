//
//  PlaylistModel.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/22/22.
//

import Foundation

struct PlaylistModel: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [ImageModel]
    let name: String
    let owner: OwnerModel
}



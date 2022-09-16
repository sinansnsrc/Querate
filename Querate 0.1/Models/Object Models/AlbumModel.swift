//
//  AlbumModel.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 3/16/22.
//

import Foundation
import FirebaseInstallations

struct AlbumModel: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [ImageModel]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [ArtistModel]
}

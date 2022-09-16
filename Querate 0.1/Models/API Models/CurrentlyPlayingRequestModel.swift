//
//  CurrentlyPlayingRequestModel.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 4/19/22.
//

import Foundation

struct CurrentlyPlayingRequestModel: Codable {
    let currently_playing_type: String
    let is_playing: Bool
    let item: CurrentlyPlayingResponse
    let progress_ms: Int
    let timestamp: Int
}

struct CurrentlyPlayingResponse: Codable {
    let album: AlbumModel
    let artists: [ArtistModel]
    let duration_ms: Int
    let explicit: Bool
    let name: String
    let popularity: Int
}


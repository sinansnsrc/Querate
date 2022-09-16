//
//  SearchModel.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 3/20/22.
//

import Foundation

struct SearchModel: Codable {
    let tracks: TrackResponse
    let albums: AlbumResponse
    let artists: ArtistResponse
    let playlists: PlaylistResponse
}

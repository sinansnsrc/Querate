//
//  ResponseModels.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 3/20/22.
//

import Foundation

struct PlaylistResponse: Codable {
    let items: [PlaylistModel]
}

struct AlbumResponse: Codable  {
    let items: [AlbumModel]
}

struct ArtistResponse: Codable {
    let items: [ArtistModel]
}

struct TrackResponse: Codable {
    let items: [TrackModel]
}

struct PlaylistCreationResponse: Codable {
    let id: String
    let name: String
}

struct UserPlaylistsResponse: Codable {
    let items: [PlaylistModel]
}

struct AlbumDetailsResponse: Codable {
    let album_type: String
    let artists: [ArtistModel]
    let external_urls: [String: String]
    let id: String
    let images: [ImageModel]
    let name: String
    let popularity: Int?
    let tracks: AlbumTracksResponse
    let release_date: String
}

struct AlbumTracksResponse: Codable {
    let items: [TrackModel]
}

struct PlaylistDetailsResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [ImageModel]
    let name: String
    let tracks: PlaylistTracksResponse
    let owner: OwnerModel
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: TrackModel
}


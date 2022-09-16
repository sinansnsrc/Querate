//
//  SocialPostModel.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 4/25/22.
//

import Foundation

struct SocialPostModel {
    let date: Date
    let title: String
    let description: String
    let rating: Int
    
    let track: TrackModel?
    let artist: ArtistModel?
    let album: AlbumModel?
    
    let type: String
    
    init(title: String, description: String, date: Date, media: TrackModel, rating: Int) {
        self.date = date
        self.title = title
        self.description = description
        
        self.track = media
        self.album = nil
        self.artist = nil
        
        self.type = "track"
        
        self.rating = rating
    }
    
    init(title: String, description: String, date: Date, media: ArtistModel, rating: Int) {
        self.date = date
        self.title = title
        self.description = description
        
        self.artist = media
        self.album = nil
        self.track = nil
        
        self.type = "artist"
        
        self.rating = rating
    }
    
    init(title: String, description: String, date: Date, media: AlbumModel, rating: Int) {
        self.date = date
        self.title = title
        self.description = description
        
        self.album = media
        self.track = nil
        self.artist = nil
        
        self.type = "album"
        
        self.rating = rating
    }
}

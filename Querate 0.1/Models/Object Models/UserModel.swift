//
//  UserModel.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/22/22.
//

import Foundation

struct UserModel: Codable {
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
    //let followers: [String: Codable?]
    let id: String
    let product: String
    let images: [UserImage]
}

struct UserImage: Codable {
    let url: String
}

//
//  OwnerModel.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 3/16/22.
//

import Foundation

struct OwnerModel: Codable {
    let display_name : String
    let external_urls: [String: String]
    let id: String
}

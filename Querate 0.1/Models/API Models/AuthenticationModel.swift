//
//  AuthenticationResponse.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/25/22.
//

import Foundation

struct AuthenticationModel: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}

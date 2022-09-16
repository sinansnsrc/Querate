//
//  DeviceModel.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 4/19/22.
//

import Foundation

struct DeviceModel: Codable {
    let id: String
    let is_active: Bool
    let is_private_session: Bool
    let name: String
}

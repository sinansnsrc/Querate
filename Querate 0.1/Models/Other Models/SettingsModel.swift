//
//  SettingsModel.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 3/14/22.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}

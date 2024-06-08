//
//  ApiModel.swift
//  Pre-Diploma
//
//  Created by Kirill Sklyarov on 15.05.2024.
//

import Foundation

// MARK: - Welcome
struct ApiModel: Codable {
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]?
    let likes: [String]?
    let id: String?
}

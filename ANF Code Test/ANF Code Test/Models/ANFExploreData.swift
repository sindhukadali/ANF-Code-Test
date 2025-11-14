//
//  ANFExploreData.swift
//  ANF Code Test
//
//  Created by Sindhu, K on 14/11/25.
//

import Foundation

struct ANFExploreData: Codable {
    let title: String
    let backgroundImage: String
    let topDescription: String?
    let promoMessage: String?
    let bottomDescription: String?
    let content: [ContentItem]?
}

struct ContentItem: Codable {
    let target: String?
    let title: String?
}

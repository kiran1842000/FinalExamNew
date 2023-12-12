//
//  NewsDetails.swift
//  Kiran_PadinhareKUnnoth_FE_8940891
//
//  Created by IS on 2023-12-10.
//

import Foundation

struct NewsDetails: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title, description: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}

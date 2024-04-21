//
//  NewsData.swift
//  Today News
//
//  Created by Nandan on 27/03/24.
//

import Foundation

// MARK: - NewsData
struct NewsData: Codable {
    let status, source, sortBy: String?
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let author, title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}

//
//  RedditPost.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 11/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import Foundation

struct RedditPost: Codable {
    let id: String?
    let author: String?
    let title: String?
    let thumbnail: String?
    let entryDate: Int
    let commentsCount: Int
    let visited: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case author = "author"
        case title = "title"
        case thumbnail = "thumbnail"
        case entryDate = "created_utc"
        case commentsCount = "num_comments"
        case visited = "visited"
    }
}

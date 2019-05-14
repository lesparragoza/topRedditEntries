//
//  RedditPost.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 11/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import Foundation

struct RedditPost: Codable {
    let id: String
    let author: String?
    let title: String?
    let thumbnail: String?
    let entryDate: Int64
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
    
    static func createFrom(persistent object: PersistentRedditPost) -> RedditPost {
        return RedditPost(id: object.id!, author: object.author, title: object.title, thumbnail: object.thumbnail, entryDate: object.entryDate, commentsCount: Int(object.commentsCount), visited: object.visited)
    }
    
    func fill(persistent: PersistentRedditPost) {
        persistent.id = self.id
        persistent.author = self.author
        persistent.title = self.title
        persistent.thumbnail = self.thumbnail
        persistent.entryDate = self.entryDate
        persistent.commentsCount = Int32(self.commentsCount)
        persistent.visited = self.visited
    }
}

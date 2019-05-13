//
//  RedditPostListingResponse.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 13/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import Foundation

struct RedditPostListingResponse: Codable {
    let data: RedditPostListingDataResponse
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct RedditPostListingDataResponse: Codable {
    let size: Int
    let children: [RedditPostListingChildrenDataResponse]
    
    enum CodingKeys: String, CodingKey {
        case size = "dist"
        case children = "children"
    }
}

struct RedditPostListingChildrenDataResponse: Codable {
    let data: RedditPost
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

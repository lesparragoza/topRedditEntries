//
//  FetchPopularPostsRequest.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 13/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import Foundation

struct FetchPopularPostsRequest: NetworkManagerRequestProtocol {
    var url = "/r/all/top?limit=50"
    var headers: [String: String]? = nil
    var parameters: String? = nil
    var httpMethod = NetworkManager.HTTPMethod.get
}

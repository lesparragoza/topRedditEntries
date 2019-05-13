//
//  MasterViewModel.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 13/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import Foundation

protocol MasterViewModelable {
    func numberOfPosts() -> Int
    func postFor(row: Int) -> RedditPost
    func viewDidLoad()
}

class MasterViewModel: MasterViewModelable {
    
    let networkManager: NetworkManagerProtocol
    var redditPostsList: [RedditPost] = []
    weak var viewControllerListener: MasterViewControllable?
    
    init(networkManager: NetworkManagerProtocol, viewControllerListener: MasterViewControllable) {
        self.networkManager = networkManager
        self.viewControllerListener = viewControllerListener
    }
    
    func numberOfPosts() -> Int {
        return redditPostsList.count
    }
    
    func postFor(row: Int) -> RedditPost {
        return redditPostsList[row]
    }
    
    func viewDidLoad() {
        fetchTopRedditPosts()
    }
}

// Private
extension MasterViewModel {
    
    private func fetchTopRedditPosts() {
        let request = FetchPopularPostsRequest()
        networkManager.request(request, responseType: RedditPostListingResponse.self) {[weak self] (response, error) in
            if error == nil, let responseData = response as? RedditPostListingResponse {
                self?.redditPostsList = responseData.data.children.map({ $0.data })
                self?.viewControllerListener?.reloadTable()
            }
        }
    }
}

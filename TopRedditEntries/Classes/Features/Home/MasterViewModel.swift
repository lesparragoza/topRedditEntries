//
//  MasterViewModel.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 13/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import Foundation
import CoreData

protocol MasterViewModelable {
    func numberOfPosts() -> Int
    func postFor(row: Int) -> RedditPost
    func getViewModelListener(viewController: DetailViewControllable, postFromRow: Int) -> DetailViewModelable
    func viewDidLoad()
}

class MasterViewModel: NSObject, MasterViewModelable {
    
    let networkManager: NetworkManagerProtocol
    var redditPostsList: [RedditPost] = []
    let fetchedResultsController: NSFetchedResultsController<PersistentRedditPost>
    let coreDataManager: CoreDataManagerProtocol
    weak var viewControllerListener: MasterViewControllable?
    
    init(networkManager: NetworkManagerProtocol, viewControllerListener: MasterViewControllable, coreDataManager: CoreDataManagerProtocol) {
        self.networkManager = networkManager
        self.viewControllerListener = viewControllerListener
        self.coreDataManager = coreDataManager
        fetchedResultsController = coreDataManager.redditPostFetchedResultsController()
        super.init()
        fetchedResultsController.delegate = self
    }
    
    func numberOfPosts() -> Int {
        return redditPostsList.count
    }
    
    func postFor(row: Int) -> RedditPost {
        return redditPostsList[row]
    }
    
    func getViewModelListener(viewController: DetailViewControllable, postFromRow: Int) -> DetailViewModelable {
        return DetailViewModel(viewControllerListener: viewController, coreDataManager: coreDataManager, currentPost: redditPostsList[postFromRow])
    }
    
    func viewDidLoad() {
        do {
            try self.fetchedResultsController.performFetch()
            if fetchedResultsController.fetchedObjects?.isEmpty ?? true {
                fetchTopRedditPosts()
            } else {
                fetchObjects()
            }
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
}

// Private
extension MasterViewModel {
    
    private func fetchTopRedditPosts() {
        let request = FetchPopularPostsRequest()
        networkManager.request(request, responseType: RedditPostListingResponse.self) {[weak self] (response, error) in
            if error == nil, let responseData = response as? RedditPostListingResponse {
                _ = responseData.data.children.map({ self?.coreDataManager.save(post: $0.data) })
                    try? self?.fetchedResultsController.performFetch()
                self?.fetchObjects()
            }
        }
    }
    
    private func fetchObjects() {
        redditPostsList = fetchedResultsController.fetchedObjects?.map({ RedditPost.createFrom(persistent: $0) }) ?? []
        viewControllerListener?.reloadTable()
    }
}

extension MasterViewModel: NSFetchedResultsControllerDelegate {
    
}

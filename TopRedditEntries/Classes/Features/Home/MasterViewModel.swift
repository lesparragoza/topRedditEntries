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
    func deletePostFrom(row: Int)
    func refreshData()
    func dismissAllPosts()
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
    
    func deletePostFrom(row: Int){
        coreDataManager.delete(post: postFor(row: row))
    }
    
    func dismissAllPosts() {
        deleteAllPosts()
        redditPostsList = []
        viewControllerListener?.reloadTable()
    }
    
    func getViewModelListener(viewController: DetailViewControllable, postFromRow: Int) -> DetailViewModelable {
        return DetailViewModel(viewControllerListener: viewController, coreDataManager: coreDataManager, currentPost: redditPostsList[postFromRow])
    }
    
    func viewDidLoad() {
        loadFetchedResultsController()
    }
    
    func refreshData() {
        deleteAllPosts()
        loadFetchedResultsController()
    }
    
    func loadFetchedResultsController() {
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
    
    private func deleteAllPosts() {
        coreDataManager.deleteAllData()
    }
    
    private func fetchTopRedditPosts() {
        let request = FetchPopularPostsRequest()
        networkManager.request(request, responseType: RedditPostListingResponse.self) {[weak self] (response, error) in
            if error == nil, let responseData = response as? RedditPostListingResponse {
                _ = responseData.data.children.map({ self?.coreDataManager.save(post: $0.data) })
                self?.coreDataManager.saveCurrentStack()
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
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewControllerListener?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if indexPath?.section == 0 {
            switch type {
            case .insert:
                break
            case .delete:
                guard let currentIndexPath = indexPath else { return }
                redditPostsList.remove(at: currentIndexPath.row)
                viewControllerListener?.deleteCellFor(indexPath: currentIndexPath)
            case .update:
                guard let currentIndexPath = indexPath else { return }
                guard let persistentRedditPost = anObject as? PersistentRedditPost else { return }
                guard currentIndexPath.row < redditPostsList.count else { return }
                redditPostsList[currentIndexPath.row] = RedditPost.createFrom(persistent: persistentRedditPost)
                viewControllerListener?.updateCellFor(indexPath: currentIndexPath)
            case .move:
                break
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewControllerListener?.endUpdates()
    }
}

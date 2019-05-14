//
//  CoreDataManager.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 13/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func redditPostFetchedResultsController() -> NSFetchedResultsController<PersistentRedditPost>
    func save(post: RedditPost)
    func markAsVisited(post: RedditPost)
    func delete(post: RedditPost)
    func deleteAllData()
    func saveCurrentStack()
}

class CoreDataManager: CoreDataManagerProtocol {
    
    private let persistentContainer = NSPersistentContainer(name: "TopRedditEntries")
    private let serialQueue = DispatchQueue(label: "savingQueue")
    
    init() {
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }
    
    func redditPostFetchedResultsController() -> NSFetchedResultsController<PersistentRedditPost> {
        let fetchRequest: NSFetchRequest<PersistentRedditPost> = PersistentRedditPost.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "entryDate", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func save(post: RedditPost) {
        serialQueue.sync {
            if let persistentPost = NSManagedObject(entity: PersistentRedditPost.entity(), insertInto: persistentContainer.viewContext) as? PersistentRedditPost {
                post.fill(persistent: persistentPost)
            }
        }
    }
    
    func saveCurrentStack() {
        try? persistentContainer.viewContext.save()
    }
    
    func markAsVisited(post: RedditPost) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersistentRedditPost.entity().name!)
        request.predicate = NSPredicate(format: "id = %@", post.id)
        request.returnsObjectsAsFaults = false
        if let result = try? persistentContainer.viewContext.fetch(request), let persistentPost = result.first as? PersistentRedditPost {
            persistentPost.visited = true
            try? persistentContainer.viewContext.save()
        }
    }
    
    func delete(post: RedditPost) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersistentRedditPost.entity().name!)
        request.predicate = NSPredicate(format: "id = %@", post.id)
        request.returnsObjectsAsFaults = false
        if let result = try? persistentContainer.viewContext.fetch(request), let persistentPost = result.first as? PersistentRedditPost {
            persistentContainer.viewContext.delete(persistentPost)
            try? persistentContainer.viewContext.save()
        }
    }
    
    func deleteAllData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: PersistentRedditPost.entity().name!)
        request.returnsObjectsAsFaults = false
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
}

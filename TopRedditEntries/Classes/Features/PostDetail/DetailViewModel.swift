//
//  DetailViewModel.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 14/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol DetailViewModelable {
    func getPost() -> RedditPost?
    func saveInPhotoLibrary(image: UIImage)
    func updateVisitedStatus()
}

class DetailViewModel: NSObject, DetailViewModelable {
    
    var redditPost: RedditPost? = nil
    let coreDataManager: CoreDataManagerProtocol
    let viewControllerListener: DetailViewControllable
    
    init(viewControllerListener: DetailViewControllable, coreDataManager: CoreDataManagerProtocol, currentPost: RedditPost? = nil) {
        self.viewControllerListener = viewControllerListener
        self.redditPost = currentPost
        self.coreDataManager = coreDataManager
    }
    
    func getPost() -> RedditPost? {
        return redditPost
    }
    
    func saveInPhotoLibrary(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        viewControllerListener.imageFinishedSaving(withError: error)
    }
    
    func updateVisitedStatus(){
        if let post = redditPost {
            coreDataManager.markAsVisited(post: post)
        }
    }

}

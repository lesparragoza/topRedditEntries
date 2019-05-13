//
//  DetailViewController.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 11/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    
    var redditPost: RedditPost?
    
    func fillUI() {
        guard let post = redditPost else { return }
        usernameLabel.text = post.author
        timeLabel.text = Date(timeIntervalSince1970: TimeInterval(post.entryDate)).getDateSpecifications()
        titleLabel.text = post.title
        commentsLabel.text = String(post.commentsCount) + " comments"
        if let url = post.thumbnail, let imageThumbnail = URL(string: url) {
            imageView.load(url: imageThumbnail, placeholder: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fillUI()
    }

}


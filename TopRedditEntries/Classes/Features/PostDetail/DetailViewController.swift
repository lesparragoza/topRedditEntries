//
//  DetailViewController.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 11/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import UIKit

protocol DetailViewControllable: class {
    func imageFinishedSaving(withError error: Error?)
}

class DetailViewController: UIViewController, DetailViewControllable {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var saveImageButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    let imageCellHeightDefaultConstraint = CGFloat(200.0)
    
    var viewModelListener: DetailViewModelable?
    
    func fillUIWith(redditPost: RedditPost?) {
        guard let post = redditPost else { emptyView.isHidden = false; return }
        emptyView.isHidden = true
        usernameLabel.text = post.author
        timeLabel.text = Date(timeIntervalSince1970: TimeInterval(post.entryDate)).getDateSpecifications()
        titleLabel.text = post.title
        commentsLabel.text = String(post.commentsCount) + " comments"
        if let url = post.thumbnail, url.verifyUrl(), let imageThumbnail = URL(string: url) {
            imageViewHeightConstraint.constant = imageCellHeightDefaultConstraint
            imageView.load(url: imageThumbnail, placeholder: nil)
            imageView.isHidden = false
            saveImageButton.isHidden = false
        }else {
            imageViewHeightConstraint.constant = CGFloat(0.0)
            imageView.isHidden = true
            saveImageButton.isHidden = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fillUIWith(redditPost: viewModelListener?.getPost())
    }
    
    @IBAction func saveImageButtonPressed(_ sender: Any) {
        if let currentImage = imageView.image {
            viewModelListener?.saveInPhotoLibrary(image: currentImage)
        } else {
            self.showAlertWithOkAction(andTitle: "Save error", message: "Your image couldn't be saved")
        }
    }
    
    func imageFinishedSaving(withError error: Error?) {
        if let error = error {
            self.showAlertWithOkAction(andTitle: "Save error", message: error.localizedDescription)
        } else {
            self.showAlertWithOkAction(andTitle: "Saved", message: "Your image has been saved to your photos")
        }
    }
}


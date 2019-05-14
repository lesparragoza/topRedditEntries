//
//  DetailViewController.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 11/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var saveImageButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    let imageCellHeightDefaultConstraint = CGFloat(200.0)
    
    var redditPost: RedditPost?
    
    func fillUI() {
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
        fillUI()
    }
    
    @IBAction func saveImageButtonPressed(_ sender: Any) {
        if let currentImage = imageView.image {
            UIImageWriteToSavedPhotosAlbum(currentImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            self.showAlertWithOkAction(andTitle: "Save error", message: "Your image couldn't be saved")
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            self.showAlertWithOkAction(andTitle: "Save error", message: error.localizedDescription)
        } else {
            self.showAlertWithOkAction(andTitle: "Saved", message: "Your image has been saved to your photos")
        }
    }
}


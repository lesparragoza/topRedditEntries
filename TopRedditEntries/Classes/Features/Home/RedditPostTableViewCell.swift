//
//  RedditPostTableViewCell.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 13/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import UIKit

class RedditPostTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var postPic: UIImageView!
    @IBOutlet weak var readStatusView: UIView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var imageCellWidthConstraint: NSLayoutConstraint!
    let imageCellWidthDefaultConstraint = CGFloat(80.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundCellView.layer.cornerRadius = 14
        backgroundCellView.layer.shadowOffset = CGSize(width: 0, height: 4)
        backgroundCellView.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.2).cgColor
        backgroundCellView.layer.shadowOpacity = 1
        backgroundCellView.layer.shadowRadius = 9
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillUI(with post: RedditPost){
        usernameLabel.text = post.author
        timeLabel.text = Date(timeIntervalSince1970: TimeInterval(post.entryDate)).getDateSpecifications()
        commentsLabel.text = String(post.commentsCount) + " comments"
        readStatusView.isHidden = post.visited
        postTitleLabel.text = post.title
        if let url = post.thumbnail, url.verifyUrl(), let imageThumbnail = URL(string: url) {
            imageCellWidthConstraint.constant = imageCellWidthDefaultConstraint
            postPic.load(url: imageThumbnail, placeholder: nil)
            postPic.isHidden = false
        } else {
            imageCellWidthConstraint.constant = CGFloat(0.0)
            postPic.isHidden = true
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
    }
    
    
}

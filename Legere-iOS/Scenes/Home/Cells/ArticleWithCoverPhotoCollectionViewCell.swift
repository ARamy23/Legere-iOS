//
//  ArticleWithCoverPhotoCollectionViewCell.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 6/24/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

class ArticleWithCoverPhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var numberOfReads: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!

    var article: Article? {
        didSet {
            coverPhotoImageView.image = article?.coverPhoto?.convertToUIImage()
            articleTitleLabel.text = article?.title
            
            profilePictureImageView.image = article?.author?.profilePicture?.convertToUIImage()
            usernameLabel.text = article?.author?.name
            
            numberOfReads.text = "\(article?.reads ?? 0)"
            numberOfLikes.text = "\(article?.numberOfLikes ?? 0)"
        }
    }
    
}

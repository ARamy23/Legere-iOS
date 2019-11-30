//
//  ArticleDetails.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/5/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation

public final class ArticleDetails: Codable {
    var article: Article?
    var isLikedByCurrentUser: Bool?
    
    init(article: Article) {
        self.article = article
    }
}

extension ArticleDetails: Equatable {
    public static func ==(lhs: ArticleDetails, rhs: ArticleDetails) -> Bool {
        return lhs.article == rhs.article && lhs.isLikedByCurrentUser == rhs.isLikedByCurrentUser
    }
}

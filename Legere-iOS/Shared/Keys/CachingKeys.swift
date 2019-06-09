//
//  CachingKeys.swift
//  EvenTask
//
//  Created by Ahmed Meguid on 12/7/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import Foundation

enum CachingKey: String {
    case user = "user"
    case token = "token"
    case articles = "articles"
    
    // MARK: - Creating Articles
    case draftTitle = "draftTitle"
    case draftBody = "draftBody"
    case draftCoverPhoto = "draftCoverPhoto"
}

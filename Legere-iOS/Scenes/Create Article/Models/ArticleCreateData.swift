//
//  ArticleCreateData.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/19/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation

public struct ArticleCreateData: Codable {
    let title: String
    let details: String
    let coverPhoto: String?
}

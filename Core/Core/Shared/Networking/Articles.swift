//
//  ArticlesService.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Moya

enum ArticlesService {
    case allArticles
    case articleDetails(id: Int)
    case didRead(articleId: Int)
    case didLike(articleId: Int)
    case createArticle(article: ArticleCreateData)
}

extension ArticlesService: BaseTargetType {
    var path: String {
        switch self {
        case .allArticles, .createArticle:
            return "/api/articles"
        case .articleDetails(id: let id):
            return "/api/articles/\(id)"
        case .didRead(articleId: let id):
            return "/api/articles/\(id)/read"
        case .didLike(articleId: let id):
            return "/api/articles/\(id)/like"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .allArticles:
            return .get
        case .articleDetails:
            return .get
        case .didRead:
            return .put
        case .didLike:
            return .put
        case .createArticle:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .allArticles:
            return .requestPlain
        case .articleDetails:
            return .requestPlain
        case .didRead:
            return .requestPlain
        case .didLike:
            guard let userID = UserDefaultsManager.getObject(User.self, key: .user)?.id else { fatalError() }
            return .requestParameters(parameters: ["userID": userID.uuidString], encoding: JSONEncoding.default)
        case .createArticle(article: let article):
            return .requestJSONEncodable(article)
        }
    }
}

struct ArticlesServiceManager {
    let provider = MoyaProvider<ArticlesService>(plugins: [NetworkLoggerPlugin(verbose: true)])
}

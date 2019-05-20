//
//  CreateArticleInteractor.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/19/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import Promises

final class CreateArticleInteractor: BaseInteractor {
    var title: String?
    var body: String?
    
    init(title: String?, body: String?, base: BaseInteractor) {
        super.init(network: base.network, cache: base.cache)
        self.title = title
        self.body = body
    }
    
    override func validate() throws {
        try super.validate()
        try NotEmpty(value: title, key: .titleField).orThrow()
        try NotEmpty(value: body, key: .bodyField).orThrow()
    }
    
    override func process<T>(_ model: T.Type) -> Promise<T> where T : Decodable, T : Encodable {
        let article = ArticleCreateData(title: self.title ?? "", details: self.body ?? "")
        return network.callModel(model: model, api: ArticlesService.createArticle(article: article))
    }
}

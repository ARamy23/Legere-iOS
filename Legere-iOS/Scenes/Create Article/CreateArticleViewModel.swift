//
//  CreateArticleViewModel.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/19/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import SimpleTwoWayBinding
import Promises

final class CreateArticleViewModel: BaseViewModel {
    var title: Observable<String> = Observable("")
    var body: Observable<String> = Observable("")
    
    override init(cache: CacheProtocol, router: RouterProtocol, network: NetworkProtocol) {
        super.init(cache: cache, router: router, network: network)
        title.value = cache.getObject(String.self, key: .draftTitle) ?? ""
        body.value = cache.getObject(String.self, key: .draftBody) ?? ""
    }
    
    func publish() {
        CreateArticleInteractor(title: title.value, body: body.value, base: baseInteractor).execute(Article.self).then { [weak self] article in
            guard let self = self else { return }
            self.cache.removeObject(key: .draftTitle)
            self.cache.removeObject(key: .draftBody)
            self.title.value = ""
            self.body.value = ""
            self.router.switchTabBar(to: .feed)
        }.catch(handleError)
    }
}


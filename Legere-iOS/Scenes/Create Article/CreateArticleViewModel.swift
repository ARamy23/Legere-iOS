//
//  CreateArticleViewModel.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/19/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import RxSwift
import RxCocoa
import Promises

final class CreateArticleViewModel: BaseViewModel {
    var title = BehaviorRelay<String>(value: "")
    var body = BehaviorRelay<String>(value: "")
    
    override init(cache: CacheProtocol, router: RouterProtocol, network: NetworkProtocol) {
        super.init(cache: cache, router: router, network: network)
        title.accept(cache.getObject(String.self, key: .draftTitle) ?? "")
        body.accept(cache.getObject(String.self, key: .draftBody) ?? "")
    }
    
    func publish() {
        CreateArticleInteractor(title: title.value, body: body.value, base: baseInteractor).execute(Article.self).then { [weak self] article in
            guard let self = self else { return }
            self.cache.removeObject(key: .draftTitle)
            self.cache.removeObject(key: .draftBody)
            self.title.accept("")
            self.body.accept("")
            self.router.switchTabBar(to: .feed)
        }.catch(handleError)
    }
}


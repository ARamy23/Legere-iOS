//
//  BaseViewModel.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import RxSwift

public class BaseViewModel {
    var router: RouterProtocol
    var cache: CacheProtocol
    
    var disposeBag = DisposeBag()
    
    var baseInteractor: BaseInteractor
    
    init(cache: CacheProtocol, router: RouterProtocol, network: NetworkProtocol) {
        self.cache = cache
        self.router = router
        self.baseInteractor = BaseInteractor(network: network, cache: cache)
    }
    
    public func handleError(error: Error) {
        router.toast(title: "Error", message: error.localizedDescription)
    }
}

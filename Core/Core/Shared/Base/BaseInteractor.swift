//
//  BaseInteractor.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import Promises

public class BaseInteractor {
    var cache: CacheProtocol
    var network: NetworkProtocol
    
    init(network: NetworkProtocol, cache: CacheProtocol) {
        self.cache = cache
        self.network = network
    }
    
    public func execute<T: Codable>(_ model: T.Type) -> Promise<T> {
        do {
            extract()
            try validate()
            return process(model)
        } catch let error {
            return Promise<T>.init(error)
        }
    }
    
    public func validate() throws {
        try ToSeeIfIsReachable().orThrow()
    }
    
    /// Use this to extract values from cache or network before you can execute the command
    public func extract() {
        // Override
    }
    
    public func process<T: Codable>(_ model: T.Type) -> Promise<T> {
        return Promise<T>.init(NSError(domain: "Error", code: 100, userInfo: nil))
    }
}

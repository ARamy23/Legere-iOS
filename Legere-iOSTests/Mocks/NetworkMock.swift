//
//  NetworkMock.swift
//  Legere-iOSTests
//
//  Created by Ahmed Ramy on 5/7/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import Promises

@testable import Legere_iOS

class NetworkMock: NetworkProtocol {
    
    var object: Codable?
    var error: NetworkError?
    
    init() { }
    
    init(error: NetworkError) {
        self.error = error
    }
    
    init(object: Codable) {
        self.object = object
    }
    
    func callModel<T, U>(model: T.Type, api: U) -> Promise<T>  where T : Decodable, T : Encodable, U : BaseTargetType {
        return Promise<T>(on: .main) { fulfill, reject in
            if let object = self.object as? T {
                fulfill(object)
            } else {
                reject(self.error ?? NetworkError.networkFail(error: ""))
            }
        }
    }
}

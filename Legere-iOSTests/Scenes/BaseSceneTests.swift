//
//  BaseSceneTests.swift
//  Legere-iOSTests
//
//  Created by Ahmed Ramy on 5/7/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import XCTest

class BaseSceneTests: XCTestCase {
    
    var router: RouterMock!
    var cache: CacheMock!
    var network: NetworkMock!
    
    override func setUp() {
        cache = CacheMock()
        router = RouterMock()
        network = NetworkMock()
    }
    
    func assertRouterError(_ error: Error) {
        let expectedError = error.localizedDescription
        XCTAssertEqual(router.actions.count, 1)
        XCTAssertEqual(router.actions[0], .toast(expectedError))
    }
    
}

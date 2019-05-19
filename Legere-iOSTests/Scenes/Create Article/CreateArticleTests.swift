//
//  CreateArticleTests.swift
//  Legere-iOSTests
//
//  Created by Ahmed Ramy on 5/19/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import XCTest

@testable import Legere_iOS
@testable import Promises

final class CreateArticleTests: BaseSceneTests {

    var viewModel: CreateArticleViewModel!
    
    override func setUp() {
        super.setUp()
        initialize()
    }
    
    func initialize() {
        viewModel = CreateArticleViewModel(cache: cache, router: router, network: network)
    }

    override func tearDown() {
        super.tearDown()
        viewModel = nil
        Reachability.testingValue = nil
    }

    func testShowingToastErrorWhenNoInternet() {
        // Given
        Reachability.testingValue = false
        
        // When
        viewModel.publish()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.unreachable.localizedDescription
        XCTAssertEqual(router.actions.count, 1)
        XCTAssertEqual(router.actions[0], .toast(expectedError))
    }

    func testShowingToastErrorWhenTryingToPublishWithEmptyTitle() {
        // Given nothing
        
        // When
        viewModel.publish()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.emptyValue(key: .titleField)
        assertRouterError(expectedError)
    }
    
    func testShowingToastErrorWhenTryingToPublishWithEmptyBody() {
        // Given
        viewModel.title.value = "Title"
        
        // When
        viewModel.publish()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.emptyValue(key: .bodyField)
        assertRouterError(expectedError)
    }
    
    func testPublishHappyScenarioDeletesCachedTitleAndCachedBody() {
        // Given
        let articleCreateData = ArticleCreateData(title: "Hi", details: "Hello")
        network = NetworkMock(object: articleCreateData)
        initialize()
        viewModel.title.value = "Hi"
        viewModel.body.value = "Hello"
        
        // When
        viewModel.publish()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let cachedTitle = cache.getObject(String.self, key: .draftTitle)
        let cachedBody = cache.getObject(String.self, key: .draftBody)
        
        XCTAssertEqual(cachedTitle, nil)
        XCTAssertEqual(cachedBody, nil)
    }

    
    func testPublishHappyScenarioGoesToFeedScreen() {
        // Given
        let incomingArticle = Article(title: "Hi", details: "Hello", userID: "")
        network = NetworkMock(object: incomingArticle)
        initialize()
        viewModel.title.value = "Hi"
        viewModel.body.value = "Hello"
        
        // When
        viewModel.publish()
        _ = waitForPromises(timeout: 10)
        
        // Then
        XCTAssertEqual(router.actions.count, 1)
        XCTAssertEqual(router.actions[0], .tabSwitch(.feed))
    }
    
    func testHappyScenarioPerformance() {
        let incomingArticle = Article(title: "Hi", details: "Hello", userID: "")
        network = NetworkMock(object: incomingArticle)
        initialize()
        viewModel.title.value = "Hi"
        viewModel.body.value = "Hello"
        self.measure {
            viewModel.publish()
            _ = waitForPromises(timeout: 10)
        }
    }
}

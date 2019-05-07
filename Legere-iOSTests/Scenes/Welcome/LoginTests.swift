//
//  LoginTests.swift
//  Legere-iOSTests
//
//  Created by Ahmed Ramy on 5/7/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import XCTest

@testable import Legere_iOS
@testable import Promises

class LoginTests: BaseSceneTests {

    var viewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        initialize()
    }
    
    func initialize() {
        viewModel = LoginViewModel(cache: cache, router: router, network: network)
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
        viewModel.login()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.unreachable.localizedDescription
        XCTAssertEqual(router.actions.count, 1)
        XCTAssertEqual(router.actions[0], .toast(expectedError))
    }
    
    func testingLoginWithEmptyUsernameShouldAlertWithError() {
        // Given nothing
        
        // When
        viewModel.login()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.emptyValue(key: .usernameField)
        assertRouterError(expectedError)
    }
    
    func testingLoginWithEmptyPasswordShouldAlertWithError() {
        // Given
        viewModel.username.value = "admin"
        // When
        viewModel.login()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.emptyValue(key: .passwordField)
        assertRouterError(expectedError)
    }
    
    func testingLoginWithUsernameContainingSpaceShouldAlertWithError() {
        // Given
        viewModel.username.value = "م ش م ح ت ر م"
        viewModel.password.value = "123456"
        // When
        viewModel.login()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.notValid(reason: .usernameContainsSpaces)
        assertRouterError(expectedError)
    }
    
    func testingLoginWithPasswordLessThanSixCharacters() {
        // Given
        viewModel.username.value = "admin"
        viewModel.password.value = "12345"
        
        // When
        viewModel.login()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.notValid(reason: .passwordTooShort)
        assertRouterError(expectedError)
    }
    
    func testingHappyScenario() {
        // Given
        let token = Token(id: "", token: "how you doin 😉", userID: "")
        network = NetworkMock(object: token)
        initialize()
        viewModel.username.value = "admin"
        viewModel.password.value = "123456"
        
        // When
        viewModel.login()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let cachedToken = cache.getObject(Token.self, key: .token)
        XCTAssertEqual(cachedToken?.token ?? "", token.token ?? "nope")
        
        
        XCTAssertEqual(router.actions[0], .present(UITabBarController()))
    }
    
    func testLoginFlowPerformance() {
        let token = Token(id: "", token: "how you doin 😉", userID: "")
        network = NetworkMock(object: token)
        initialize()
        viewModel.username.value = "admin"
        viewModel.password.value = "123456"
        
        self.measure {
            self.viewModel.login()
            _ = waitForPromises(timeout: 10)
        }
    }
}

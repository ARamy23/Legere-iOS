//
//  RegisterTests.swift
//  Legere-iOSTests
//
//  Created by Ahmed Ramy on 5/7/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import XCTest

@testable import Legere_iOS
@testable import Promises


final class RegisterTests: BaseSceneTests {

    var viewModel: RegisterViewModel!
    
    override func setUp() {
        super.setUp()
        initialize()
    }

    override func tearDown() {
        super.tearDown()
        viewModel = nil
        Reachability.testingValue = nil
    }
    
    func initialize() {
        viewModel = RegisterViewModel(cache: cache, router: router, network: network)
    }

    func testShowToastErrorWhenNoInternet() {
        // Given
        Reachability.testingValue = false
        
        // When
        viewModel.register()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.unreachable.localizedDescription
        XCTAssertEqual(router.actions.count, 1)
        XCTAssertEqual(router.actions[0], .toast(expectedError))
    }
    
    func testRegisterWithEmptyUsernameShouldAlertWithError() {
        // Given nothing
        
        // When
        viewModel.register()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.emptyValue(key: .usernameField)
        assertRouterError(expectedError)
    }
    
    func testRegisterWithEmptyNameShouldAlertWithError() {
        // Given
        viewModel.username.value = "admin"
        
        // When
        viewModel.register()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.emptyValue(key: .nameField)
        assertRouterError(expectedError)
    }
    
    func testRegisterWithEmptyPasswordShouldAlertWithError() {
        // Given
        viewModel.username.value = "7amada"
        viewModel.name.value = "Hamada"
        
        // When
        viewModel.register()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.emptyValue(key: .passwordField)
        assertRouterError(expectedError)
    }
    
    func testRegisterWithEmptyConfirmPasswordShouldAlertWithError() {
        // Given
        viewModel.username.value = "7amada"
        viewModel.name.value = "Hamada"
        viewModel.password.value = "123456"
        
        // When
        viewModel.register()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.emptyValue(key: .confirmPasswordField)
        assertRouterError(expectedError)
    }
    
    func testRegisterWithUsernameThatContainsSpacesShouldAlertWithError() {
        // Given
        viewModel.username.value = "م ش م ح ت ر م"
        viewModel.name.value = "Hamada"
        viewModel.password.value = "123456"
        viewModel.confirmPassword.value = "123456"
        
        // When
        viewModel.register()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.notValid(reason: .usernameContainsSpaces)
        assertRouterError(expectedError)
    }
    
    func testRegsiterWithNameThatContainsNumbersShouldAlertWithError() {
        // Given
        viewModel.username.value = "7amada"
        viewModel.name.value = "7amada"
        viewModel.password.value = "123456"
        viewModel.confirmPassword.value = "123456"
        
        // When
        viewModel.register()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.notValid(reason: .nameContainsNumbers)
        assertRouterError(expectedError)
    }
    
    func testRegisterWithNameThatContainsEmojisShouldAlertWithError() {
        // Given
        viewModel.username.value = "7amada"
        viewModel.name.value = "🤔"
        viewModel.password.value = "123456"
        viewModel.confirmPassword.value = "123456"
        
        // When
        viewModel.register()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.notValid(reason: .nameContainsEmojis)
        assertRouterError(expectedError)
    }
    
    func testRegisterWithPasswordShorterThanSixCharactersShouldAlertWithError() {
        // Given
        viewModel.username.value = "7amada"
        viewModel.name.value = "Hamada"
        viewModel.password.value = "1234"
        viewModel.confirmPassword.value = "1234"
        
        // When
        viewModel.register()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.notValid(reason: .passwordTooShort)
        assertRouterError(expectedError)
    }
    
    func testRegisterWithPasswordsThatDoesntMatchEachOtherShouldAlertWithError() {
        // Given
        viewModel.username.value = "7amada"
        viewModel.name.value = "Hamada"
        viewModel.password.value = "123456"
        viewModel.confirmPassword.value = "654321"
        
        // When
        viewModel.register()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let expectedError = ValidationError.notValid(reason: .passwordsNotMatching)
        assertRouterError(expectedError)
    }
    
    func testRegisterHappyScenario() {
        // Given
        let user = User(id: UUID(uuidString: ""), name: "Hamada", username: "7amada")
        network = NetworkMock(object: user)
        initialize()
        viewModel.username.value = "7amada"
        viewModel.name.value = "Hamada"
        viewModel.password.value = "123456"
        viewModel.confirmPassword.value = "123456"
        
        // When
        viewModel.register()
        _ = waitForPromises(timeout: 10)
        
        // Then
        let cachedUser = cache.getObject(User.self, key: .user)
        XCTAssertEqual(cachedUser?.username, user.username)
        
        XCTAssertEqual(router.actions.count, 0) // no errors
    }

    func testRegisterFlowPerformance() {
        viewModel.username.value = "7amada"
        viewModel.name.value = "Hamada"
        viewModel.password.value = "123456"
        viewModel.confirmPassword.value = "123456"
        self.measure {
            viewModel.register()
            _ = waitForPromises(timeout: 10)
        }
    }

}

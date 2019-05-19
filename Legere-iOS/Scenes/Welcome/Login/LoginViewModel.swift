//
//  LoginViewModel.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import SimpleTwoWayBinding
import SwiftEntryKit

final class LoginViewModel: BaseViewModel {
    var username: Observable<String> = Observable()
    var password: Observable<String> = Observable()
    
    func login() {
        LoginInteractor(username: username.value, password: password.value, base: baseInteractor).execute(Token.self).then { [weak self] (token) in
            guard let self = self else { return }
            self.cache.saveObject(token, key: .token)
            SwiftEntryKit.dismiss()
            let tabBar = MainTabBarController()
            tabBar.router = self.router
            self.router.present(view: tabBar)
            }.catch(handleError)
    }
}


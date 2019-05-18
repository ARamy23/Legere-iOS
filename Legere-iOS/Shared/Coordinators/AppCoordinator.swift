//
//  AppCoordinator.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/18/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var router: RouterProtocol { get set }
    
    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func start() {
        if didLoginBefore() {
            openHomeScene()
        } else {
            openWelcomeScene()
        }
    }
    
    private func openWelcomeScene() {
        guard let vc = AppStoryboard.Welcome.initialViewController() as? BaseViewController else { fatalError() }
        router.presentedView = vc
        vc.router = self.router
    }
    
    private func openHomeScene() {
        let vc = MainTabBarController()
        router.presentedView = vc
        vc.router = router
    }
    
    private func didLoginBefore() -> Bool {
        return UserDefaultsManager.getObject(Token.self, key: .token) != nil
    }
}

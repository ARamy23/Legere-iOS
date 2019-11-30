//
//  AppCoordinator.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/18/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit
import Core

public protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var router: RouterProtocol { get set }
    
    func start()
}

public class MainCoordinator: Coordinator {
    public var childCoordinators: [Coordinator] = []
    
    public var router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    public func start() {
        if didLoginBefore() {
            openHomeScene()
        } else {
            openWelcomeScene()
        }
    }
    
    private func openWelcomeScene() {
        guard let navCon = AppStoryboard.Welcome.initialViewController() as? UINavigationController, let vc = navCon.viewControllers.first as? BaseViewController else { fatalError() }
        router.presentedView = navCon
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

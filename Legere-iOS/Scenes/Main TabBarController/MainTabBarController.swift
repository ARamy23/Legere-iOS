//
//  MainTabBarController.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/18/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    var router: RouterProtocol = Router()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = setupTabsScenes()
        self.tabBar.tintColor = .black
    }
    
    private func setupTabsScenes() -> [UINavigationController] {
        return [
            setup(scene: HomeViewController.instantiate(fromAppStoryboard: .Home),
                  tabIconTitle: "Feed",
                  image: #imageLiteral(resourceName: "ic_feed"),
                  selectedImage: #imageLiteral(resourceName: "ic_feed"),
                  navBarTitle: "Home"),
            setup(scene: CreateArticleViewController.instantiate(fromAppStoryboard: .CreateArticle),
                  tabIconTitle: "Write",
                  image: #imageLiteral(resourceName: "ic_create_article_unselected"),
                  selectedImage: #imageLiteral(resourceName: "ic_create_article_selected"),
                  navBarTitle: "New Article")]
    }
    
    private func setup(scene: BaseViewController, tabIconTitle: String, image: UIImage, selectedImage: UIImage?, navBarTitle: String) -> UINavigationController {
        scene.router = router
        scene.tabBarItem.title = tabIconTitle
        scene.tabBarItem.image = image
        scene.tabBarItem.selectedImage = image
        let navCon = UINavigationController(rootViewController: scene)
        scene.navigationItem.title = navBarTitle
        scene.navigationController?.navigationBar.prefersLargeTitles = true
        return navCon
    }
}

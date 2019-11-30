//
//  ExternalProtocols.swift
//
//  Created by Ahmed Meguid on 12/4/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import UIKit
import Moya
import Promises

public protocol CacheProtocol {
    func getData(key: CachingKey) -> [Data]?
    func saveData(_ data: Data?, key: CachingKey)
    func getObject<T: Codable>(_ object: T.Type, key: CachingKey) -> T?
    func saveObject<T: Codable>(_ object: T, key: CachingKey)
    func removeObject(key: CachingKey)
}

public protocol NetworkProtocol {
    func callModel<T: Codable, U: BaseTargetType>(model: T.Type, api: U) -> Promise<T>
}

public enum TabBarScenes: Int {
    case feed = 0
    case writeArticle = 1
    case profile = 2
}

public protocol RouterProtocol {
    var presentedView: UIViewController! {set get}
    func present(view: UIViewController)
    func push(view: UIViewController)
    func startActivityIndicator()
    func stopActivityIndicator()
    func dismiss()
    func pop()
    func segue(storyboard: AppStoryboard, vc: UIViewController.Type)
    func alert(title: String, message: String, actions: [(title: String, style: UIAlertAction.Style)])
    func toast(title: String, message: String)
    func switchTabBar(to tabIndex: TabBarScenes)
    func alertWithAction(title: String, message: String, actions: [(title: String, style: UIAlertAction.Style, action: () -> Void)])
}
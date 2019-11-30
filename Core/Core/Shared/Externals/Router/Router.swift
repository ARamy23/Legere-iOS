//
//  Router.swift
//
//  Created by Ahmed Meguid on 12/5/18.
//  Copyright © 2018 Ahmed Meguid. All rights reserved.
//

import UIKit
import SwiftMessages

public class Router: RouterProtocol {
    
    public var presentedView: UIViewController!
    
    public func present(view: UIViewController) {
        presentedView.present(view, animated: true, completion: nil)
    }
    
    public func push(view: UIViewController) {
        presentedView.navigationController?.pushViewController(view)
    }
    
    public func startActivityIndicator() { }
    
    public func stopActivityIndicator() { }
    
    public func dismiss() {
        presentedView.dismiss(animated: true, completion: nil)
    }
    
    public func pop() {
        _ = presentedView.navigationController?.popViewController(animated: true)
    }
    
    public func segue(storyboard: AppStoryboard, vc: UIViewController.Type) {
        presentedView
            .navigationController?
            .pushViewController(storyboard.viewController(viewControllerClass: vc))
    }
    
    public func alert(title: String, message: String, actions: [(title: String, style: UIAlertAction.Style)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.map({UIAlertAction(title: $0.title, style: $0.style, handler: nil)}).forEach({alert.addAction($0)})
        presentedView.present(alert, animated: true)
    }
    
    public func alertWithAction(title: String, message: String, actions: [(title: String, style: UIAlertAction.Style, action: () -> Void)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.map { action in
                UIAlertAction(title: action.title, style: action.style, handler: { (_) in
                    action.action()
                })
            }.forEach {
                alert.addAction($0)
            }
        presentedView.present(alert, animated: true)
    }
    
    public func toast(title: String, message: String) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.info)
        view.configureContent(title: title, body: message, iconImage: #imageLiteral(resourceName: "ic_alert_dark"))
        view.configureDropShadow()
        view.button?.isHidden = true
        
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .statusBar)
        config.duration = .seconds(seconds: 3)
        config.interactiveHide = true
        
        
        SwiftMessages.show(config: config, view: view)
    }
    
    public func switchTabBar(to tabIndex: TabBarScenes) {
        guard let tabBarController = presentedView.tabBarController else { return }
        tabBarController.selectedIndex = tabIndex.rawValue
        presentedView = tabBarController.selectedViewController
    }
}

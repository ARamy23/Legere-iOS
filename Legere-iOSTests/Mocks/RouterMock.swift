//
//  RouterMock.swift
//  Legere-iOSTests
//
//  Created by Ahmed Ramy on 5/7/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import UIKit

@testable import Legere_iOS

enum RoutingAction: Equatable {
    case present(_ vc: UIViewController)
    case activityStart
    case activityStop
    case dismiss
    case pop
    case segue(_ storyboard: AppStoryboard, _ vc: UIViewController.Type)
    case alert(_ message: String)
    case toast(_ message: String)
    
    static public func ==(lhs: RoutingAction, rhs: RoutingAction) -> Bool {
        switch (lhs, rhs) {
        case let (.present(a), .present(b)): return "\(type(of: a))" == "\(type(of: b))"
        case let (.alert(a), .alert(b)): return a == b
        case let (.toast(a), .toast(b)): return a == b
        case let (.segue(a, b), .segue(c, d)): return a == c && b == d
        case (.activityStart, .activityStart),
             (.activityStop, .activityStop),
             (.dismiss, .dismiss),
             (.pop, .pop):
            return true
        default:
            return false
        }
    }
}

class RouterMock: RouterProtocol {
    var presentedView: BaseViewController!
    
    var actions: [RoutingAction] = []
    
    func present(view: UIViewController) {
        actions.append(.present(view))
    }
    
    func segue(storyboard: AppStoryboard, vc: UIViewController.Type) {
        actions.append(.segue(storyboard, vc))
    }
    
    func alert(title: String, message: String, actions: [(title: String, style: UIAlertAction.Style)]) {
        self.actions.append(.alert(message))
    }
    
    func toastError(title: String, message: String) {
        self.actions.append(.toast(message))
    }
    
    func startActivityIndicator() {
        actions.append(.activityStart)
    }
    
    func stopActivityIndicator() {
        actions.append(.activityStop)
    }
    
    func dismiss() {
        actions.append(.dismiss)
    }
    
    func pop() {
        actions.append(.pop)
    }
}
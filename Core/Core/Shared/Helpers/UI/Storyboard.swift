//
//  Storyboard.swift
//  Legere
//
//  Created by Ahmed Ramy on 5/3/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import Foundation
import UIKit

/// Usage
///
/// let greenScene = GreenVC.instantiate(fromAppStoryboard: .Main)
///
/// let greenScene = AppStoryboard.Main.viewController(viewControllerpublic class: GreenVC.self)
///
/// let greenScene = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: GreenVC.storyboardID)
public enum AppStoryboard: String {
    case Home
    case Welcome
    case CreateArticle
    case Profile
    
    var instance: UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    public func viewController<T: UIViewController>(viewControllerClass: T.Type,
                                             public function: String = #function,
                                             line: Int = #line,
                                             file: String = #file,
                                             customStoryboardID: String = "") -> T {
        
        let storyboardID = (customStoryboardID != "") ? customStoryboardID : (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    public func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

public extension UIViewController {
    class var storyboardID: String {
        
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

//
//  BaseViewController.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/4/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit
import RxSwift

public class BaseViewController: UIViewController {
    
    var cache: CacheProtocol = UserDefaultsManager()
    var network: NetworkProtocol = MoyaManager()
    var router: RouterProtocol = Router()
    
    let disposeBag = DisposeBag()
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialize()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        router.presentedView = self
        setupNavbar()
        bind()
    }
    
    /// Initializes the necessary contents for the view to load correctly
    public func initialize() {
        // Override
    }
    
    /// Binds the entities of the controller to the viewModel
    public func bind() {
        // Override
    }
    
    private func setupNavbar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

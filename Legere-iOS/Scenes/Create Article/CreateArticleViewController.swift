//
//  CreateArticleViewController.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/18/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit
import SimpleTwoWayBinding

class CreateArticleViewController: BaseViewController {
    
    @IBOutlet weak var titleTextView: PlaceholderTextView!
    @IBOutlet weak var bodyTextView: PlaceholderTextView!
    
    var viewModel: CreateArticleViewModel!
    
    override func bind() {
        super.bind()
        viewModel = CreateArticleViewModel(cache: cache, router: router, network: network)
        
        titleTextView.bind(with: viewModel.title)
        bodyTextView.bind(with: viewModel.body)
    }
    
    override func initialize() {
        super.initialize()
        titleTextView.text = cache.getObject(String.self, key: .draftTitle)
        bodyTextView.text = cache.getObject(String.self, key: .draftBody)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cache.saveObject(titleTextView.text ?? "", key: .draftTitle)
        cache.saveObject(bodyTextView.text ?? "", key: .draftBody)
    }
    
    @IBAction func publishArticle(_ sender: Any) {
        viewModel.publish()
    }
}

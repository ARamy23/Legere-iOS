//
//  CreateArticleViewController.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/18/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateArticleViewController: BaseViewController {
    
    @IBOutlet weak var titleTextView: PlaceholderTextView!
    @IBOutlet weak var bodyTextView: PlaceholderTextView!
    @IBOutlet weak var coverPictureImageView: UIImageView!
    
    var viewModel: CreateArticleViewModel!
    var picker: RxMediaPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker = RxMediaPicker(delegate: self)
    }
    
    override func bind() {
        super.bind()
        viewModel = CreateArticleViewModel(cache: cache, router: router, network: network)
        titleTextView.rx.text.orEmpty.bind(to: viewModel.title).disposed(by: disposeBag)
        bodyTextView.rx.text.orEmpty.bind(to: viewModel.body).disposed(by: disposeBag)
        viewModel.coverPhoto.bind(to: coverPictureImageView.rx.image).disposed(by: disposeBag)
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
    
    @IBAction func addCoverPicture(_ sender: Any) {
        viewModel.presentAlertForPhotoInput()
    }
}

extension CreateArticleViewController: RxMediaPickerDelegate {
    func present(picker: UIImagePickerController) {
        self.present(picker, animated: true)
    }
    
    func dismiss(picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

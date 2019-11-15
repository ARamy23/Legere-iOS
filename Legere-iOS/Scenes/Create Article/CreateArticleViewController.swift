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
import Highlightr
import SnapKit

class CreateArticleViewController: BaseViewController {
    
    @IBOutlet weak var titleTextView: PlaceholderTextView!
    @IBOutlet weak var bodyTextView: PlaceholderTextView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var coverPictureImageView: UIImageView!
    var textViews: [UITextView] = []
    var highlightr = CodeAttributedString().highlightr
    var viewModel: CreateArticleViewModel!
    var wholeText: String = ""
    var picker: RxMediaPicker!
    let toolBar = UIToolbar()
    override func viewDidLoad() {
        super.viewDidLoad()
        picker = RxMediaPicker(delegate: self)
        addKeyboardToolbar()
    }
    
    func addKeyboardToolbar()  {
        toolBar.sizeToFit()
        let codeButton = UIBarButtonItem(title: "</>", style: .plain, target: self, action: #selector(openCodeEditor))
        toolBar.items = [codeButton]
        bodyTextView.inputAccessoryView = toolBar
    }
    
    private func createCodeBlock(from code: String) -> UIView {
        let codeBlockView = UIView()
        codeBlockView.backgroundColor = .white
        codeBlockView.borderColor = .systemGray
        codeBlockView.cornerRadius = 8
        codeBlockView.addShadow(ofColor: .black, radius: 12, offset: .zero, opacity: 0.24)
        codeBlockView.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(100)
        }
        
        let codeTextView = UITextView()
        codeTextView.attributedText = highlightr.highlight(code, as: "swift", fastRender: true)
        codeTextView.isEditable = false
        codeTextView.isSelectable = false
        codeBlockView.addSubview(codeTextView)
        codeTextView.snp.makeConstraints { (make) in
            make.edges.equalTo(codeBlockView).inset(8)
        }
        
        return codeBlockView
    }
    
    private func createContentBlock() -> PlaceholderTextView {
        let contentTextView = PlaceholderTextView()
        contentTextView.text = ""
        contentTextView.becomeFirstResponder()
        contentTextView.font = bodyTextView.font
        contentTextView.textColor = bodyTextView.textColor
        contentTextView.placeholder = "Continue writing here..."
        contentTextView.backgroundColor = .clear
        contentTextView.inputAccessoryView = toolBar
        contentTextView.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(100)
        }
        return contentTextView
    }
    
    private func createContentBlock(with text: String) -> PlaceholderTextView {
        let contentTextView = createContentBlock()
        contentTextView.text = text
        return contentTextView
    }
    
    @objc func openCodeEditor() {
        let vc = CodeEditingViewController.instantiate(fromAppStoryboard: .CreateArticle)
        vc.didFinishTypingCode = { [weak self] code in
            guard let self = self else { return }
            let codeTextView = self.createCodeBlock(from: code)
            self.contentStackView.addArrangedSubview(codeTextView)
            self.textViews.append(codeTextView.subviews.last as! UITextView)
            let nextContentTextView = self.createContentBlock()
            self.contentStackView.addArrangedSubview(nextContentTextView)
            self.textViews.append(nextContentTextView)
        }
        self.router.push(view: vc)
    }
    
    override func bind() {
        super.bind()
        viewModel = CreateArticleViewModel(cache: cache, router: router, network: network)
        titleTextView.rx.text.orEmpty.bind(to: viewModel.title).disposed(by: disposeBag)
        bodyTextView.rx.text.orEmpty.bind(to: viewModel.body).disposed(by: disposeBag)
        viewModel.coverPhoto.bind(to: coverPictureImageView.rx.image).disposed(by: disposeBag)
    }
    
    private func initializeTextViews(from wholeText: String) {
        let textForTextviews = wholeText.components(separatedBy: "~")
        textForTextviews.enumerated().forEach { index, paragraph in
            let isCodeBlock = paragraph.contains("```")
            if index == 0 && !isCodeBlock {
                bodyTextView.text = paragraph
            } else if index == textForTextviews.count - 1 && isCodeBlock {
                contentStackView.addArrangedSubview(createContentBlock())
            } else if isCodeBlock {
                let code = paragraph.replacingOccurrences(of: "`", with: "")
                let codeBlock = createCodeBlock(from: code)
                contentStackView.addArrangedSubview(codeBlock)
            } else {
                contentStackView.addArrangedSubview(createContentBlock(with: paragraph))
            }
        }
    }
    
    override func initialize() {
        super.initialize()
        titleTextView.text = cache.getObject(String.self, key: .draftTitle)
        wholeText = cache.getObject(String.self, key: .draftBody) ?? ""
        initializeTextViews(from: wholeText)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cache.saveObject(titleTextView.text ?? "", key: .draftTitle)
        collectTextFromTextViews()
        cache.saveObject(wholeText, key: .draftBody)
    }
    
    private func collectTextFromTextViews() {
        textViews.forEach { textView in
            if textView is PlaceholderTextView {
                wholeText += textView.text
            } else {
                wholeText += "~\n```\n\(String(describing: textView.text ?? ""))\n```\n~"
            }
        }
        viewModel.body.accept(wholeText)
    }
    
    @IBAction func publishArticle(_ sender: Any) {
        collectTextFromTextViews()
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

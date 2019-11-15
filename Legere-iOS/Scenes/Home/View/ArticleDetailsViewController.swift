//
//  ArticleDetailsViewController.swift
//  Legere-iOS
//
//  Created by Ahmed Ramy on 5/5/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit
import Highlightr

final class ArticleDetailsViewController: BaseViewController {
    
    @IBOutlet weak var articleCoverImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleBodyTextView: UITextView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var peopleLikedThisLabel: UILabel!
    
    @IBOutlet weak var peopleBarView: UIView!
    @IBOutlet weak var peopleBarRoundView: UIView!
    @IBOutlet weak var includingYouBarRoundView: UIView!
    @IBOutlet weak var includingYouView: UIView!
    @IBOutlet weak var socialViewStackView: UIStackView!
    @IBOutlet weak var isLovedImageView: UIImageView!
    
    var highlightr = CodeAttributedString().highlightr
    var viewModel: HomeViewModel!
    var articleDetails: ArticleDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHero()
        self.configureViewFromModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func initialize() {
        super.initialize()
        peopleBarRoundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        includingYouBarRoundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        socialViewStackView.subviews.enumerated().forEach { (arg) in
            let (index, view) = arg
            view.layer.zPosition = 3 - CGFloat(index)
        }
        
        guard let articleId = articleDetails.article?.id else { return }
        didRead(articleId: articleId)
    }
    
    func setupHero() {
        self.hero.isEnabled = true
        self.view.hero.id = "ironMan"
    }
    
    func configureViewFromModel() {
        guard let article = articleDetails.article else { return }
        articleCoverImageView.image = article.coverPhoto?.convertToUIImage()
        articleTitleLabel?.text = article.title
        articleBodyTextView?.text = article.details
        isLovedImageView?.image = (articleDetails.isLikedByCurrentUser == true) ? #imageLiteral(resourceName: "ic_love") : #imageLiteral(resourceName: "ic_love_unselected")
        let numberOfLikes = article.numberOfLikes
        peopleLikedThisLabel?.text = "\(numberOfLikes ?? 0) People Liked This"
        
        peopleBarView?.isHidden = numberOfLikes ?? 0 < 1
        includingYouView?.isHidden = articleDetails.isLikedByCurrentUser != true
    }
    
    override func bind() {
        if let articleId = articleDetails.article?.id {
            viewModel.getArticleDetails(articleId)
        }
        viewModel.articleDetails
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] articleDetails in
                guard let self = self, articleDetails.article != nil else { return }
                self.articleDetails = articleDetails
                self.configureViewFromModel()
                self.initializeTextViews(from: articleDetails.article?.details ?? "")
            }).disposed(by: disposeBag)
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
        contentTextView.isEditable = false
        contentTextView.isSelectable = false
        contentTextView.font = articleBodyTextView.font
        contentTextView.textColor = articleBodyTextView.textColor
        contentTextView.placeholder = "Continue writing here..."
        contentTextView.backgroundColor = .clear
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
    
    private func initializeTextViews(from wholeText: String) {
        let textForTextviews = wholeText.components(separatedBy: "~")
        textForTextviews.enumerated().forEach { index, paragraph in
            let isCodeBlock = paragraph.contains("```")
            if index == 0 && !isCodeBlock {
                articleBodyTextView.text = paragraph
            } else if isCodeBlock {
                let code = paragraph.replacingOccurrences(of: "`", with: "")
                let codeBlock = createCodeBlock(from: code)
                contentStackView.addArrangedSubview(codeBlock)
            } else {
                contentStackView.addArrangedSubview(createContentBlock(with: paragraph))
            }
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        router.dismiss()
    }
    
    @IBAction func loveButtonTapped(_ sender: Any) {
        guard let articleId = articleDetails.article?.id else { return }
        viewModel.didLike(articleId)
    }
    
    fileprivate func didRead(articleId: Int) {
        viewModel.didRead(articleId)
    }
}

//
//  HomeViewController.swift
//  Legere
//
//  Created by Ahmed Ramy on 5/3/19.
//  Copyright (c) 2019 Ahmed Ramy. All rights reserved.
//

import UIKit
import Hero
import SwifterSwift

public final class HomeViewController: BaseViewController {
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    var viewModel: HomeViewModel!
    var articles: [ArticleWithAuthor] = []
    
    var refresher: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        setupCollectionView()
        setupPullToRefresh()
    }
    
    private func setupCollectionView() {
        self.feedCollectionView.delegate = self
        self.feedCollectionView.dataSource = self
        self.feedCollectionView.register(nib: UINib(nibName: "\(ArticleSearchbarView.self)", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: ArticleSearchbarView.self)
        let layout = feedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        self.feedCollectionView.register(nibWithCellClass: ArticleCollectionViewCell.self)
        self.feedCollectionView.register(nibWithCellClass: ArticleWithCoverPhotoCollectionViewCell.self)
    }
    
    private func setupPullToRefresh() {
        self.refresher = UIRefreshControl()
        self.feedCollectionView.alwaysBounceVertical = true
        self.refresher?.tintColor = UIColor.black
        self.refresher?.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
        self.feedCollectionView.addSubview(refresher!)
    }
    
    override func initialize() {
        super.initialize()
        viewModel.getAllArticles()
    }
    
    override func bind() {
        super.bind()
        viewModel = HomeViewModel(cache: cache, router: router, network: network)
        viewModel.articles
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] articles in
                guard let self = self else { return }
                self.articles = articles
                self.feedCollectionView.reloadData()
                self.refresher?.endRefreshing()
            }).disposed(by: disposeBag)
    }
    
    @objc private func refreshArticles() {
        viewModel.getAllArticles()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: ArticleSearchbarView.self, for: indexPath)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.width - 50, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let article = articles[indexPath.row]
        switch article.article?.type {
        case .withCoverPhoto?:
            let cell = collectionView.dequeueReusableCell(withClass: ArticleWithCoverPhotoCollectionViewCell.self, for: indexPath)
            cell.article = articles[indexPath.row]
            return cell
        case .plainText?:
            let cell = collectionView.dequeueReusableCell(withClass: ArticleCollectionViewCell.self, for: indexPath)
            cell.article = articles[indexPath.row].article
            return cell
        default:
            fatalError("Article Type doesn't have a specific cell to be matched to")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let article = self.articles[indexPath.row].article else { return }
        let vc = ArticleDetailsViewController.instantiate(fromAppStoryboard: .Home)
        vc.viewModel = self.viewModel
        vc.articleDetails = ArticleDetails(article: article)
        router.present(view: vc)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let article = articles[indexPath.row].article
        let width: CGFloat = self.view.width - 50
        let actualHeight = article?.details?.height(withConstrainedWidth: width, font: .systemFont(ofSize: 17, weight: .light)) ?? 0.0
        let height: CGFloat = (actualHeight <= 300) ? actualHeight : 300
        return CGSize(width: width, height: height + 169 + 40)
    }
}

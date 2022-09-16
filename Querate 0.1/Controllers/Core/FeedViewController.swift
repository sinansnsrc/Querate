//
//  ViewController.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/22/22.
//

import UIKit

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var postViewModels = [FeedPostCellViewModel]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postViewModels.count //TBR
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedPostCollectionViewCell.identifier, for: indexPath) as? FeedPostCollectionViewCell else { return UICollectionViewCell() }
        
        let viewModel = postViewModels[indexPath.row]
    
        cell.configure(viewModel: viewModel)

        return cell
    }
    
    private var feedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return FeedViewController.createFeedLayout()})
    
    static func createFeedLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(600)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(230)), subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        
        return section
    }

    private let pageTitle: UILabel = {
        let pageTitle = UILabel()
        
        pageTitle.text = "Home."
        pageTitle.font = .systemFont(ofSize: 40, weight: .bold)
        
        return pageTitle
    }()
    
    private let pageIndicator: UILabel = {
        let pageIndicator = UILabel()
        
        pageIndicator.backgroundColor = UIColor().qPurple
        
        pageIndicator.layer.masksToBounds = true
        pageIndicator.layer.cornerRadius = 8.0
        
        return pageIndicator
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Social"
        view.backgroundColor = UIColor().qBlack
        
        view.addSubview(pageTitle)
        view.addSubview(pageIndicator)
        view.addSubview(feedCollectionView)
        
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        
        feedCollectionView.register(FeedPostCollectionViewCell.self, forCellWithReuseIdentifier: FeedPostCollectionViewCell.identifier)
        
        feedCollectionView.backgroundColor = UIColor().qBlack
        
        getData()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        pageTitle.sizeToFit()
        
        pageTitle.frame = CGRect(x: 5, y: view.safeAreaInsets.top, width: view.width, height: pageTitle.height)
        pageIndicator.frame = CGRect(x: 0, y: 0, width: view.width, height: view.safeAreaInsets.top)
        
        feedCollectionView.alwaysBounceHorizontal = false
        feedCollectionView.showsVerticalScrollIndicator = false
        feedCollectionView.showsHorizontalScrollIndicator = false
        
        feedCollectionView.sizeToFit()
        
        feedCollectionView.frame = CGRect(x:0, y: pageTitle.bottom, width: view.width, height: view.bottom - 100 - pageTitle.bottom)
    }
    
    func getData() {
        let group = DispatchGroup()
        
        var posts: [FeedPostCellViewModel]?
        
        group.enter()
        
        FirebaseManager.shared.fetchPosts { result in
            posts = result
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.configureModels(posts: posts!)
        }
    }
    
    func configureModels(posts: [FeedPostCellViewModel]) {
        if(posts.count != postViewModels.count) {
            postViewModels.removeAll()
            postViewModels.append(contentsOf: posts)
        }
        
        feedCollectionView.reloadData()
        
        var timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self!.getData()
        }
    }
}


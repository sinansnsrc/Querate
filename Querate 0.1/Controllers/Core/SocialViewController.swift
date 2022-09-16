//
//  SocialViewController.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 5/28/22.
//

import UIKit

class SocialViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendActivityViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendActivityCollectionViewCell.identifier, for: indexPath) as? FriendActivityCollectionViewCell else { return UICollectionViewCell() }
        
        let viewModel = friendActivityViewModels[indexPath.row]
        cell.configure(viewModel: viewModel)
        
        return cell
    }
    
    private var friendActivityCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return SocialViewController.createLayout()})

    private static func createLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160)), subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        
        return section
    }
    
    private var friendActivityViewModels = [FriendActivityCellViewModel]()
    
    private let pageTitle: UILabel = {
        let pageTitle = UILabel()
        
        pageTitle.text = "Social."
        pageTitle.font = .systemFont(ofSize: 40, weight: .bold)
        
        return pageTitle
    }()
    
    private let pageIndicator: UILabel = {
        let pageIndicator = UILabel()
        
        pageIndicator.backgroundColor = UIColor().qYellow
        
        pageIndicator.layer.masksToBounds = true
        pageIndicator.layer.cornerRadius = 8.0
        
        return pageIndicator
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().qBlack
        
        friendActivityCollectionView.dataSource = self
        friendActivityCollectionView.delegate = self
        
        friendActivityCollectionView.register(FriendActivityCollectionViewCell.self, forCellWithReuseIdentifier: FriendActivityCollectionViewCell.identifier)
        
        friendActivityCollectionView.showsHorizontalScrollIndicator = false
        friendActivityCollectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(pageTitle)
        view.addSubview(pageIndicator)
        view.addSubview(friendActivityCollectionView)
        
        getData()
        
        var timer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: true) { [weak self] _ in
            self!.getData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        pageTitle.sizeToFit()
        friendActivityCollectionView.sizeToFit()
        
        pageTitle.frame = CGRect(x: 5, y: view.safeAreaInsets.top, width: view.width, height: pageTitle.height)
        pageIndicator.frame = CGRect(x: 0, y: 0, width: view.width, height: view.safeAreaInsets.top)
        friendActivityCollectionView.frame = CGRect(x:0, y: pageTitle.bottom, width: view.width, height: view.bottom - 100 - pageTitle.bottom)
    }
    
    func getData() {
        let group = DispatchGroup()
        group.enter()
        
        var activities: [FriendActivityCellViewModel]?
        
        FirebaseManager.shared.fetchActivities { result in
            activities = result
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.configureModels(activities: activities!)
        }
    }
    
    func configureModels(activities: [FriendActivityCellViewModel]) {
        friendActivityViewModels.removeAll()
        friendActivityViewModels.append(contentsOf: activities)
        
        friendActivityCollectionView.reloadData()
    }
}

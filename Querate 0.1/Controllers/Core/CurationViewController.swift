//
//  CurationViewController.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/22/22.
//

import UIKit

class CurationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationCollectionViewCell.identifier, for: indexPath) as? CurationCollectionViewCell else { return UICollectionViewCell() }
        
        let viewModel = tools[indexPath.row]
        
        cell.configure(title: viewModel.name, description: viewModel.description, URL: viewModel.url)
        
        return cell
    }
    
    
    private let pageTitle: UILabel = {
        let pageTitle = UILabel()
        
        pageTitle.text = "Curate."
        pageTitle.font = .systemFont(ofSize: 40, weight: .bold)
        
        return pageTitle
    }()
    
    private let pageIndicator: UILabel = {
        let pageIndicator = UILabel()
        
        pageIndicator.backgroundColor = UIColor().qRed
        
        pageIndicator.layer.masksToBounds = true
        pageIndicator.layer.cornerRadius = 8.0
        
        return pageIndicator
    }()
    
    private var curationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return CurationViewController.createLayout()})
    
    private static func createLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160)), subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        
        return section
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        view.backgroundColor = UIColor().qBlack
        
        curationCollectionView.register(CurationCollectionViewCell.self, forCellWithReuseIdentifier: CurationCollectionViewCell.identifier)
        
        curationCollectionView.dataSource = self
        curationCollectionView.delegate = self
        
        curationCollectionView.showsVerticalScrollIndicator = false
        curationCollectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(pageTitle)
        view.addSubview(pageIndicator)
        view.addSubview(curationCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        pageTitle.sizeToFit()
        
        pageTitle.frame = CGRect(x: 5, y: view.safeAreaInsets.top, width: view.width, height: pageTitle.height)
        pageIndicator.frame = CGRect(x: 0, y: 0, width: view.width, height: view.safeAreaInsets.top)
        curationCollectionView.sizeToFit()
        curationCollectionView.frame = CGRect(x:0, y: pageTitle.bottom, width: view.width, height: view.bottom - 100 - pageTitle.bottom)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = tools[indexPath.row]
        present(WebViewController(pageTitle: viewModel.name, url: viewModel.url), animated: true)
    }
    
    var tools = [CurationViewModel]()

    func configure() {
        var title = ""
        var description = ""
        var url: URL
        
        for i in 0...5 {
            switch i {
            case 0:
                title = "Obscurify"
                description = "Compare the obscurity of your music taste with the rest of the world with this web tool!"
                url = URL(string: "https://obscurifymusic.com/home")!
            case 1:
                title = "MoodPlaylist"
                description = "Generate a playlist based on mood and music taste by answering two questions!"
                url = URL(string: "https://www.moodplayl.ist/#")!
            case 2:
                title = "Boil The Frog"
                description = "Bridge the gap between any two artists by creating a nearly seamless playlist between the two."
                url = URL(string: "http://boilthefrog.playlistmachinery.com/")!
            case 3:
                title = "Whisperify"
                description = "View stats, generate Spotify music quizzes, and challenge friends. How well do you know your favourite songs?"
                url = URL(string: "https://whisperify.net/")!
            case 4:
                title = "Kaleidosync"
                description = "View a mesmerising music visualizer to accompany your music!"
                url = URL(string: "https://kaleidosync-beta.herokuapp.com/")!
            case 5:
                title = "Colorify"
                description = "Generate color templates based on your favorite album cover's color schemes!"
                url = URL(string: "https://colorify.live/")!
            default:
                title = "Obscurify"
                description = "It's pretty cool app that can be used to do a variety of things that are all music related! This description is a placeholder and does not have any meaning at all!"
                url = URL(string: "https://obscurifymusic.com/home")!
            }
            tools.append(CurationViewModel(name: title, description: description, url: url))
        }
    }
    
}

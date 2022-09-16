//
//  LibraryViewController.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/22/22.
//

import UIKit

class LibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(playlistViewModels.count)
        return playlistViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as? NewReleasesCollectionViewCell else { return UICollectionViewCell() }
        
        cell.color = UIColor().qGreen
        
        let viewModel = playlistViewModels[indexPath.row]
        cell.configure(with: viewModel)
        
        return cell
    }
    
    private var playlistViewModels = [NewReleasesCellViewModel]()
    private var playlists: [PlaylistModel] = []
    
    private var userPlaylistsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return LibraryViewController.createNewReleasesLayout()})
    
    private static func createNewReleasesLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(600)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)), subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        
        return section
    }

    private let pageTitle: UILabel = {
        let pageTitle = UILabel()
        
        pageTitle.text = "Library."
        pageTitle.font = .systemFont(ofSize: 40, weight: .bold)
        
        return pageTitle
    }()
    
    private let pageIndicator: UILabel = {
        let pageIndicator = UILabel()
        
        pageIndicator.backgroundColor = UIColor().qGreen
        
        pageIndicator.layer.masksToBounds = true
        pageIndicator.layer.cornerRadius = 8.0
        
        return pageIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().qBlack
        
        userPlaylistsCollectionView.showsVerticalScrollIndicator = false
        
        userPlaylistsCollectionView.backgroundColor = UIColor().qBlack
        userPlaylistsCollectionView.dataSource = self
        userPlaylistsCollectionView.delegate = self
        userPlaylistsCollectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        
        view.addSubview(pageTitle)
        view.addSubview(pageIndicator)
        view.addSubview(userPlaylistsCollectionView)
        
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        
        pageTitle.sizeToFit()
        pageTitle.frame = CGRect(x: 5, y: view.safeAreaInsets.top, width: view.width, height: pageTitle.height)
        pageIndicator.frame = CGRect(x: 0, y: 0, width: view.width, height: view.safeAreaInsets.top)
        
        userPlaylistsCollectionView.frame = CGRect(x: 0, y: pageTitle.bottom, width: view.width, height: view.bottom - 100 - pageTitle.bottom)
    }
    
    private func getData() {
        let group = DispatchGroup()
        
        var userPlaylists: UserPlaylistsResponse?
        
        group.enter()
        
        APIManager.shared.getUserPlaylists { result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let model):
                userPlaylists = model
            case .failure(let model):
                break
            }
        }
        
        group.notify(queue: .main) {
            guard let playlists = userPlaylists?.items else {
                return
            }
            
            self.configureModels(playlists: playlists)
        }
    }
    
    func configureModels(playlists: [PlaylistModel]) {
        self.playlists = playlists
        
        playlistViewModels.append(contentsOf: playlists.compactMap({
            return NewReleasesCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: "", artistName: $0.owner.display_name)
        }))
        
        userPlaylistsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        let mediaScreen = ListMediaViewController(playlist: playlist, color: UIColor().qGreen)
        present(mediaScreen, animated: true)
    }
}

//
//  NewReleasesViewController.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 3/16/22.
//

import UIKit

class BrowseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.newReleasesCollectionView) {
            return newReleasesViewModels.count
        }
        else {
            return featuredPlaylistsViewModels.count
        }
    }
    
    private let pageTitle: UILabel = {
        let pageTitle = UILabel()
        
        pageTitle.text = "Discover."
        pageTitle.font = .systemFont(ofSize: 40, weight: .bold)
        
        return pageTitle
    }()
    
    private let newReleasesTitle: UILabel = {
        let newReleasesTitle = UILabel()
        
        newReleasesTitle.text = "New Releases."
        newReleasesTitle.font = .systemFont(ofSize: 26, weight: .semibold)
        
        return newReleasesTitle
    }()
    
    private let featuredPlaylistsTitle: UILabel = {
        let featuredPlaylistsTitle = UILabel()
        
        featuredPlaylistsTitle.text = "Featured Playlists."
        featuredPlaylistsTitle.font = .systemFont(ofSize: 26, weight: .semibold)
        
        return featuredPlaylistsTitle
    }()
    
    private let pageIndicator: UILabel = {
        let pageIndicator = UILabel()
        
        pageIndicator.backgroundColor = UIColor().qBlue
        
        pageIndicator.layer.masksToBounds = true
        pageIndicator.layer.cornerRadius = 8.0
        
        return pageIndicator
    }()
    
    private var newReleasesViewModels = [NewReleasesCellViewModel]()
    private var featuredPlaylistsViewModels = [FeaturedPlaylistCellViewModel]()
    
    private var albums : [AlbumModel] = []
    private var playlists: [PlaylistModel] = []
    
    private var newReleasesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return BrowseViewController.createNewReleasesLayout()})
    
    private static func createNewReleasesLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(240)), subitem: item, count: 2)
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(240)), subitem: verticalGroup, count: 1)
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private var featuredPlaylistsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return
        BrowseViewController.createFeaturedPlaylistsLayout()})
    
    private static func createFeaturedPlaylistsLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(240), heightDimension: .absolute(300)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(240), heightDimension: .absolute(240)), subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == self.newReleasesCollectionView) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as? NewReleasesCollectionViewCell else { return UICollectionViewCell() }
            
            cell.color = UIColor().qBlue
            
            let viewModel = newReleasesViewModels[indexPath.row]
            cell.configure(with: viewModel)
            
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistsCollectionViewCell else { return UICollectionViewCell() }
            
            let viewModel = featuredPlaylistsViewModels[indexPath.row]
            cell.configure(with: viewModel)
            
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().qBlack
        
        featuredPlaylistsCollectionView.backgroundColor = UIColor().qBlack
        newReleasesCollectionView.backgroundColor = UIColor().qBlack
        
        newReleasesCollectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        featuredPlaylistsCollectionView.register(FeaturedPlaylistsCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier)
        
        newReleasesCollectionView.dataSource = self
        newReleasesCollectionView.delegate = self
        
        featuredPlaylistsCollectionView.dataSource = self
        featuredPlaylistsCollectionView.delegate = self
        
        view.addSubview(pageTitle)
        view.addSubview(pageIndicator)
        view.addSubview(newReleasesCollectionView)
        view.addSubview(featuredPlaylistsCollectionView)
        view.addSubview(featuredPlaylistsTitle)
        view.addSubview(newReleasesTitle)
        
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        newReleasesCollectionView.alwaysBounceVertical = false
        featuredPlaylistsCollectionView.alwaysBounceVertical = false
        
        featuredPlaylistsCollectionView.showsVerticalScrollIndicator = false
        newReleasesCollectionView.showsVerticalScrollIndicator = false
        
        
        pageTitle.sizeToFit()
        
        pageTitle.frame = CGRect(x: 5, y: view.safeAreaInsets.top, width: view.width, height: pageTitle.height)
        pageIndicator.frame = CGRect(x: 0, y: 0, width: view.width, height: view.safeAreaInsets.top)
        
        newReleasesTitle.sizeToFit()
        
        newReleasesTitle.frame = CGRect(x: 5, y: pageTitle.bottom, width: view.width, height: newReleasesTitle.height)
        
        newReleasesCollectionView.sizeToFit()
        
        newReleasesCollectionView.frame = CGRect(x: 0, y: newReleasesTitle.bottom, width: view.width, height: 240)
        
        featuredPlaylistsTitle.sizeToFit()
        
        featuredPlaylistsTitle.frame = CGRect(x: 5, y: newReleasesCollectionView.bottom, width: view.width, height: featuredPlaylistsTitle.height)
        
        featuredPlaylistsCollectionView.sizeToFit()
        
        featuredPlaylistsCollectionView.frame = CGRect(x: 0, y: featuredPlaylistsTitle.bottom, width: view.width, height: 300)
    }
    
    func getData() {
        let group = DispatchGroup()
        
        var featuredPlaylists: FeaturedPlaylistsModel?
        var newReleases: NewReleasesModel?
        
        group.enter()
        group.enter()
        
        APIManager.shared.getFeaturedPlaylists() { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model): featuredPlaylists = model
            case .failure(let error): print("* - Failed to fetch featured playlists in browse screen.")
            }
        }
        APIManager.shared.getNewReleases() { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let model): newReleases = model
            case .failure(let error): print("* - Failed to fetch new releases in browse screen.")
            }
        }
        
        group.notify(queue: .main) {
            guard let albums = newReleases?.albums.items else {
                return
            }
            guard let playlists = featuredPlaylists?.playlists.items else {
                return
            }
            
            self.configureModels(albums: albums, playlists: playlists)
        }
    }
    
    func configureModels(albums: [AlbumModel], playlists: [PlaylistModel]) {
        self.albums = albums
        self.playlists = playlists
        
        
        newReleasesViewModels.append(contentsOf: albums.compactMap({
            return NewReleasesCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), numberOfTracks: $0.total_tracks == 1 ? "\($0.total_tracks) Track" : "\($0.total_tracks) Tracks", artistName: $0.artists.first?.name ?? "-")
        }))
        
        featuredPlaylistsViewModels.append(contentsOf: playlists.compactMap({
            return FeaturedPlaylistCellViewModel(name: $0.name, artworkURL: URL(string: $0.images.first?.url ?? ""), creatorName: $0.owner.display_name)
        }))
        
        newReleasesCollectionView.reloadData()
        featuredPlaylistsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if (collectionView == self.newReleasesCollectionView) {
            let album = albums[indexPath.row]
            let mediaScreen = ListMediaViewController(album: album, color: UIColor().qBlue)
            present(mediaScreen, animated: true)
        }
        else {
            let playlist = playlists[indexPath.row]
            let mediaScreen = ListMediaViewController(playlist: playlist, color: UIColor().qBlue)
            present(mediaScreen, animated: true)
        }
    }
}

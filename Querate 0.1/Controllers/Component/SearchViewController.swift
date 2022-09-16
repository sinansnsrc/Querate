//
//  SearchViewController.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 6/5/22.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate
{
    public var presentChoice: Bool
    public var didChoose: Bool = false
    public var chosenArtist: ArtistModel?
    public var chosenTrack: TrackModel?
    public var chosenAlbum: AlbumModel?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch (results[indexPath.row].type) {
            case "track":
            chosenTrack = rawResults!.tracks.items[indexPath.row % 6]
            if(presentChoice) {
                //Play?
            }
            else {
                dismiss(animated: true)
            }
            case "album":
                chosenAlbum = rawResults!.albums.items[indexPath.row % 6]
                if(presentChoice) {
                    present(ListMediaViewController(album: chosenAlbum!, color: UIColor.white), animated: true)
                }
                else {
                    dismiss(animated: true)
                }
            case "artist":
                chosenArtist = rawResults!.artists.items[indexPath.row % 6]
                if(presentChoice) {
                    //IDFK
                }
                else {
                    dismiss(animated: true)
                }
            default:
            presentChoice = false
                chosenAlbum = nil
                chosenTrack = nil
                chosenArtist = nil
        }
        didChoose = true
    }
    
    init(shouldPresentChoice: Bool) {
        self.presentChoice = shouldPresentChoice
        chosenTrack = nil
        chosenAlbum = nil
        chosenArtist = nil
        rawResults = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        var viewModel: SearchResultViewModel
        
        if(results.isEmpty || indexPath.row >= results.count) {
            viewModel = SearchResultViewModel(title: "", owner: "", artwork: "https://i.scdn.co/image/ab6775700000ee85866e531bfd68501894ed8d26", type: "none")
        }
        else {
            viewModel = results[indexPath.row]
        }
        
        
        cell.configure(viewModel: viewModel)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 8.0
        return cell
    }
    
    var rawResults: SearchModel?
    var results = [SearchResultViewModel]()
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        APIManager.shared.getSearchQuery(query: query) { result in
            switch (result) {
            case .success(let model):
                self.rawResults = model
                
                self.results.removeAll()
                self.results.append(contentsOf: model.tracks.items.compactMap({SearchResultViewModel(title: $0.name, owner: $0.artists.map { $0.name }.joined(separator: ", "), artwork: ($0.album?.images.first!.url)!, type: "track")}))
                self.results.append(contentsOf: model.albums.items.compactMap({SearchResultViewModel(title: $0.name, owner: $0.artists.map { $0.name }.joined(separator: ", "), artwork: ($0.images.first!.url), type: "album")}))
                self.results.append(contentsOf: model.artists.items.compactMap({SearchResultViewModel(title: $0.name, owner: "The Artist.", artwork: $0.images?.first?.url ?? "https://i.scdn.co/image/ab6775700000ee85866e531bfd68501894ed8d26", type: "artist")}))
                break
            case .failure(let model):
                break
            }
            DispatchQueue.main.async {
                self.searchCollectionView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchCollectionView.backgroundColor = UIColor().qBlack
        searchCollectionView.frame = CGRect(x: 0, y: searchController.searchBar.bottom, width: view.width, height: view.height - searchController.searchBar.bottom)
    }
    
    private let searchCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)), subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        
        return section
        
    }))

    let searchController: UISearchController = {
        let viewController = UISearchController(searchResultsController: nil)
        viewController.searchBar.placeholder = "Search songs, albums, artists, or users."
        viewController.searchBar.searchBarStyle = .minimal
        viewController.definesPresentationContext = true
        viewController.automaticallyAdjustsScrollViewInsets = false
        viewController.obscuresBackgroundDuringPresentation = false
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().qBlack
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        view.addSubview(searchController.searchBar)
        view.addSubview(searchCollectionView)
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        
    }

}

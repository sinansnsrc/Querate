//
//  PlaylistViewController.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/22/22.
//

import UIKit

class ListMediaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listMediaViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListMediaCollectionViewCell.identifier, for: indexPath) as? ListMediaCollectionViewCell else { return UICollectionViewCell() }
        
        let viewModel = listMediaViewModels[indexPath.row]
        cell.configure(viewModel: viewModel, color: color!)
        
        return cell
    }
    
    private var listMediaViewModels = [ListMediaCellViewModel]()
    
    let mediaTitle: UILabel = {
        let mediaTitle = UILabel()
        mediaTitle.font = .systemFont(ofSize: 32, weight: .bold)
        return mediaTitle
    }()
    
    let mediaDescription: UILabel = {
        let mediaDescription = UILabel()
        mediaDescription.font = .systemFont(ofSize: 22, weight: .regular)
        mediaDescription.numberOfLines = 2
        mediaDescription.lineBreakMode = .byTruncatingTail
        return mediaDescription
    }()
    
    let mediaCreator: UILabel = {
        let mediaCreator = UILabel()
        mediaCreator.font = .systemFont(ofSize: 18, weight: .semibold)
        return mediaCreator
    }()
    
    let mediaImage: UIImageView = {
        let mediaImage = UIImageView()
        mediaImage.layer.masksToBounds = true
        mediaImage.layer.cornerRadius = 8.0
        mediaImage.image = UIImage(systemName: "photo")
        mediaImage.contentMode = .scaleAspectFill
        return mediaImage
    }()
    
//    private let playButton: UIButton = {
//        let playButton = UIButton()
//        playButton.layer.masksToBounds = true
//        playButton.layer.cornerRadius = 8.0
//        playButton.setImage(UIImage(systemName: "playpause.fill"), for: .normal)
//        playButton.contentMode = .scaleAspectFill
//        playButton.tintColor = UIColor().qBlack
//        return playButton
//    }()
    
    private var listMediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return ListMediaViewController.createLayout()})
    
    private static func createLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90)), subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        
        return section
    }
    
    private let album: AlbumModel?
    private let playlist: PlaylistModel?
    private var color: UIColor?
    
    init(album: AlbumModel, color: UIColor) {
        self.album = album
        self.playlist = nil
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    init(playlist: PlaylistModel, color: UIColor) {
        self.playlist = playlist
        self.album = nil
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listMediaCollectionView.dataSource = self
        listMediaCollectionView.delegate = self
        
        listMediaCollectionView.register(ListMediaCollectionViewCell.self, forCellWithReuseIdentifier: ListMediaCollectionViewCell.identifier)
        
        listMediaCollectionView.showsHorizontalScrollIndicator = false
        listMediaCollectionView.showsVerticalScrollIndicator = false
        
        configure()
        
        view.addSubview(mediaTitle)
        view.addSubview(mediaDescription)
        view.addSubview(mediaCreator)
        view.addSubview(mediaImage)
        view.addSubview(listMediaCollectionView)
//        view.addSubview(playButton)
//        playButton.backgroundColor = color
        
        view.backgroundColor = UIColor().qBlack
        listMediaCollectionView.backgroundColor = UIColor().qBlack
    }
    
    override func viewDidLayoutSubviews() {
        let imageSize = view.width / 1.5
        mediaImage.frame = CGRect(x: (view.width / 2) - (imageSize / 2), y: 5, width: imageSize, height: imageSize)
        
        mediaTitle.sizeToFit()
        mediaTitle.frame = CGRect(x: 5, y: mediaImage.bottom + 5, width: view.width, height: mediaTitle.height)
        
        mediaDescription.sizeToFit()
        mediaDescription.frame = CGRect(x: 5, y: mediaTitle.bottom + 5, width: view.width, height: mediaDescription.height)
        
        mediaCreator.sizeToFit()
        mediaCreator.frame = CGRect(x: 5, y: mediaDescription.bottom + 5, width: view.width, height: mediaCreator.height)
        
        //playButton.frame = CGRect(x: 5, y: mediaCreator.bottom + 5, width: view.width - 10, height: 45)
        
        listMediaCollectionView.frame = CGRect(x:0, y: mediaCreator.bottom + 5, width: view.width, height: view.height - mediaCreator.bottom)
    }
    
    func configure() {
        if (album != nil) {
            APIManager.shared.getAlbumDetails(album: album!) { result in
                switch(result) {
                case .success(let model):
                    self.mediaTitle.text = model.name
                    self.mediaDescription.text = "Released: \(model.release_date.split(separator: "-").reversed().joined(separator: "/"))"
                    self.mediaCreator.text = "by \(model.artists.map { $0.name }.joined(separator: ", "))"
                    self.mediaImage.sd_setImage(with: URL(string: model.images.first!.url))
                    
                    self.listMediaViewModels = model.tracks.items.compactMap({
                        ListMediaCellViewModel(track_name: $0.name, artist_name: $0.artists.map { $0.name }.joined(separator: ", "), artworkURL: model.images.first!.url)
                    })
                case .failure(let model):
                    return
                }
                DispatchQueue.main.async {
                    self.listMediaCollectionView.reloadData()
                }
            }
        }
        else {
            APIManager.shared.getPlaylistDetails(playlist: playlist!) { result in
                switch(result) {
                case .success(let model):
                    self.mediaTitle.text = model.name
                    self.mediaDescription.text = model.description
                    self.mediaCreator.text = "by \(model.owner.display_name)"
                    self.mediaImage.sd_setImage(with: URL(string: model.images.first!.url))
                    
                    self.listMediaViewModels = model.tracks.items.compactMap({
                        ListMediaCellViewModel(track_name: $0.track.name, artist_name: $0.track.artists.map { $0.name }.joined(separator: ", "), artworkURL: $0.track.album!.images.first!.url)
                    })
                case .failure(let model):
                    return
                }
                DispatchQueue.main.async {
                    self.listMediaCollectionView.reloadData()
                }
            }
        }
        
        
    }
}

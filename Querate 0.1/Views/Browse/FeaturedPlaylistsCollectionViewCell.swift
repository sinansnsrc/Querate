//
//  FeaturedPlaylistsCollectionViewCell.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 5/16/22.
//

import UIKit

class FeaturedPlaylistsCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistsCollectionViewCell"
    
    private let playlistArtImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8.0
        
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor().qBlack
        
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(playlistArtImageView)
        contentView.addSubview(creatorNameLabel)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor().qBlue.cgColor
        
        playlistNameLabel.sizeToFit()
        playlistArtImageView.sizeToFit()
        creatorNameLabel.sizeToFit()
        
        playlistArtImageView.frame = CGRect(x: 5, y: (contentView.width - 220) / 2, width: 220, height: 220)
        playlistArtImageView.layer.cornerRadius = 8.0
        
        playlistNameLabel.frame = CGRect(x: 5, y: playlistArtImageView.bottom + 5, width: 230, height: playlistNameLabel.height)
        creatorNameLabel.frame = CGRect(x: 5, y: playlistNameLabel.bottom + 5, width: 230, height: creatorNameLabel.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        playlistArtImageView.image = nil
        creatorNameLabel.text = nil
    }
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = "by \(viewModel.creatorName)"
        playlistArtImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}

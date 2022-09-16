//
//  NewReleasesCollectionViewCell.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 5/16/22.
//

import UIKit
import SDWebImage

class NewReleasesCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleasesCollectionViewCell"
    
    private let albumArtImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8.0
        
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let trackNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    public var color: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor().qBlack
        
        contentView.addSubview(albumArtImageView)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(trackNumberLabel)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = color.cgColor
        
        super.layoutSubviews()
        
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        trackNumberLabel.sizeToFit()
        
        let imageSize = contentView.height - 10
        
        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width - imageSize - 10, height: contentView.height - 10))
        
        let albumLabelHeight = min(50, artistNameLabel.height)
        
        albumArtImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        trackNumberLabel.frame = CGRect(x: albumArtImageView.right + 10, y: albumArtImageView.bottom - trackNumberLabel.height, width: contentView.width - albumArtImageView.right - 5, height: trackNumberLabel.height)
        
        albumNameLabel.frame = CGRect(x: albumArtImageView.right + 10, y: albumArtImageView.top + 5, width: albumLabelSize.width, height: albumLabelSize.height)
        
        artistNameLabel.frame = CGRect(x: albumArtImageView.right + 10, y: albumNameLabel.bottom + 5, width: contentView.width - albumArtImageView.right - 5, height: albumLabelHeight)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        trackNumberLabel.text = nil
        albumArtImageView.image = nil
    }
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        trackNumberLabel.text = viewModel.numberOfTracks
        albumArtImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}

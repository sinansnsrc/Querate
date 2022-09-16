//
//  ListMediaCollectionViewCell.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 6/5/22.
//

import UIKit
import Foundation

class ListMediaCollectionViewCell: UICollectionViewCell {
    static let identifier = "ListMediaCollectionViewCell"
    
    private let trackName: UILabel = {
        let trackName = UILabel()
        trackName.font = .systemFont(ofSize: 22, weight: .semibold)
        trackName.numberOfLines = 2
        trackName.lineBreakMode = .byTruncatingTail
        return trackName
    }()
    
    private let trackArtist: UILabel = {
        let trackArtist = UILabel()
        trackArtist.font = .systemFont(ofSize: 20, weight: .regular)
        trackArtist.numberOfLines = 2
        trackArtist.lineBreakMode = .byTruncatingTail
        return trackArtist
    }()
    
    private let trackMedia: UIImageView = {
        let mediaImage = UIImageView()
        
        mediaImage.layer.masksToBounds = true
        mediaImage.layer.cornerRadius = 8.0
        
        mediaImage.image = UIImage(systemName: "photo")
        mediaImage.contentMode = .scaleAspectFill
        return mediaImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor().qBlack
        
        contentView.addSubview(trackName)
        contentView.addSubview(trackArtist)
        contentView.addSubview(trackMedia)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = UIColor().qBlack
        
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1.5
        contentView.layer.masksToBounds = true
        
        let imageSize = contentView.height - 10
        trackMedia.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        trackName.sizeToFit()
        trackName.frame = CGRect(x: trackMedia.right + 5, y: 5, width: contentView.width - imageSize, height: trackName.height)
        
        trackArtist.sizeToFit()
        trackArtist.frame = CGRect(x: trackMedia.right + 5, y: trackName.bottom + 5, width: contentView.width - imageSize, height: trackName.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackName.text = nil
        trackArtist.text = nil
        trackMedia.image = nil
    }
    
    func configure(viewModel: ListMediaCellViewModel, color: UIColor) {
        contentView.layer.borderColor = color.cgColor
        
        trackName.text = viewModel.track_name
        trackArtist.text = viewModel.artist_name
        trackMedia.sd_setImage(with: URL(string: viewModel.artworkURL))
    }
    
}

//
//  FriendActivityCell.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 6/1/22.
//

import Foundation
import UIKit

class FriendActivityCollectionViewCell: UICollectionViewCell {
    static let identifier = "FriendActivityCollectionViewCell"
    
    private let friendName: UILabel = {
        let label  = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let albumArtImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8.0
        
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let songLabel: UILabel = {
        let label  = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let albumLabel: UILabel = {
        let label  = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label  = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label  = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor().qBlack
        
        contentView.addSubview(friendName)
        contentView.addSubview(songLabel)
        contentView.addSubview(albumLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(albumArtImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor().qYellow.cgColor
        
        friendName.sizeToFit()
        songLabel.sizeToFit()
        albumLabel.sizeToFit()
        artistLabel.sizeToFit()
        timeLabel.sizeToFit()
        
        let imageSize = contentView.height - 10
        
        friendName.frame = CGRect(x: 5, y: 5, width: contentView.width - contentView.height - 5, height: friendName.height)
        songLabel.frame = CGRect(x: 5, y: friendName.bottom + 5, width: contentView.width - contentView.height - 5, height: songLabel.height)
        albumLabel.frame = CGRect(x: 5, y: songLabel.bottom + 2.5, width: contentView.width - contentView.height - 5, height: albumLabel.height)
        artistLabel.frame = CGRect(x: 5, y: albumLabel.bottom + 2.5, width: contentView.width - contentView.height - 5, height: artistLabel.height)
        timeLabel.frame = CGRect(x: 5, y: artistLabel.bottom + 5, width: contentView.width - contentView.height - 5, height: timeLabel.height)
        albumArtImageView.frame = CGRect(x: friendName.right + 5, y: 5, width: imageSize, height: imageSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        friendName.text = nil
        songLabel.text = nil
        albumLabel.text = nil
        artistLabel.text = nil
        timeLabel.text = nil
    }
    
    func configure(viewModel: FriendActivityCellViewModel) {
        
        friendName.text = viewModel.friendName
        songLabel.text = viewModel.songName
        albumLabel.text = viewModel.album
        artistLabel.text = viewModel.artist
        timeLabel.text = "at \(viewModel.time)"
        albumArtImageView.sd_setImage(with: URL(string: viewModel.media))
    }
}

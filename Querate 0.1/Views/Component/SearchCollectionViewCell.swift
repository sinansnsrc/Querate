//
//  SearchCollectionViewCell.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 6/5/22.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchCollectionViewCell"
    
    private let mediaImage: UIImageView = {
        let mediaImage = UIImageView()
        
        mediaImage.layer.masksToBounds = true
        mediaImage.layer.cornerRadius = 8.0
        
        mediaImage.image = UIImage(systemName: "photo")
        mediaImage.contentMode = .scaleAspectFill
        return mediaImage
    }()
    
    private let mediaType: UIImageView = {
        let mediaType = UIImageView()
        
        mediaType.layer.masksToBounds = true
        mediaType.layer.cornerRadius = 8.0
        
        
        mediaType.image = UIImage(systemName: "photo")
        //mediaType.contentMode = .scaleAspectFill
        mediaType.tintColor = .black
        mediaType.backgroundColor = .white
        
        return mediaType
    }()
    
    private let mediaName: UILabel = {
        let label  = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let mediaOwner: UILabel = {
        let label  = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor().qBlack
        
        contentView.addSubview(mediaName)
        contentView.addSubview(mediaOwner)
        contentView.addSubview(mediaImage)
        contentView.addSubview(mediaType)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.backgroundColor = UIColor().qBlack
        
        mediaName.sizeToFit()
        mediaOwner.sizeToFit()
        
        let imageSize = contentView.height - 10
        
        mediaImage.frame = CGRect(x:5, y:5, width: imageSize, height: imageSize)
        mediaName.frame = CGRect(x: mediaImage.right + 5, y: 5, width: contentView.width - (2 * imageSize) - 20, height: mediaName.height)
        mediaOwner.frame = CGRect(x: mediaImage.right + 5, y: mediaName.bottom, width: contentView.width - (2 * imageSize) - 20, height: mediaOwner.height)
        mediaType.frame = CGRect(x:mediaName.right + 5, y: 5, width: imageSize, height: imageSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mediaName.text = nil
        mediaOwner.text = nil
        mediaType.image = nil
        mediaImage.image = nil
    }
    
    func configure(viewModel: SearchResultViewModel) {
        mediaName.text = viewModel.title
        mediaOwner.text = viewModel.owner
        mediaImage.sd_setImage(with: URL(string: viewModel.artwork))
        
        let config = UIImage.SymbolConfiguration(pointSize: 5)
        
        switch(viewModel.type) {
        case "track":
            mediaType.image = UIImage(systemName: "music.note", withConfiguration: config)
        case "album":
            mediaType.image = UIImage(systemName: "square.stack.fill", withConfiguration: config)
        case "artist":
            mediaType.image = UIImage(systemName: "person.fill", withConfiguration: config)
        case "none":
            mediaType.image = UIImage(systemName: "questionmark.circle.fill", withConfiguration: config)
        default:
            mediaType.image = nil
        }
    }
}

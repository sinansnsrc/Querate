//
//  FeedPostCollectionViewCell.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 5/29/22.
//

import Foundation
import UIKit
import SDWebImage

class FeedPostCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeedPostCollectionViewCell"
    
    private let userName: UILabel = {
        let userName = UILabel()
        userName.font = .systemFont(ofSize: 18, weight: .regular)
        userName.numberOfLines = 1
        userName.lineBreakMode = .byTruncatingTail
        return userName
    }()
    
    private let postTitle: UILabel = {
        let postTitle = UILabel()
        postTitle.font = .systemFont(ofSize: 24, weight: .bold)
        postTitle.numberOfLines = 2
        postTitle.lineBreakMode = .byTruncatingTail
        return postTitle
    }()
    
    private let postDescription: UILabel = {
        let postDescription = UILabel()
        postDescription.font = .systemFont(ofSize: 18, weight: .regular)
        postDescription.numberOfLines = 4
        postDescription.lineBreakMode = .byTruncatingTail
        return postDescription
    }()
    
    private let postDate: UILabel = {
        let postDate = UILabel()
        postDate.font = .systemFont(ofSize: 18, weight: .light)
        postDate.numberOfLines = 1
        postDate.lineBreakMode = .byTruncatingTail
        return postDate
    }()
    
    private let postRating: UILabel = {
        let postRating = UILabel()
        postRating.font = .systemFont(ofSize: 26, weight: .bold)
        postRating.numberOfLines = 1
        postRating.lineBreakMode = .byTruncatingTail
        return postRating
    }()
    
    private let mediaName: UILabel = {
        let mediaName = UILabel()
        mediaName.font = .systemFont(ofSize: 24, weight: .semibold)
        mediaName.numberOfLines = 2
        mediaName.lineBreakMode = .byTruncatingTail
        return mediaName
    }()
    
    private let mediaOwner: UILabel = {
        let mediaOwner = UILabel()
        mediaOwner.font = .systemFont(ofSize: 18, weight: .regular)
        mediaOwner.numberOfLines = 0
        mediaOwner.lineBreakMode = .byTruncatingTail
        return mediaOwner
    }()
    
    private let mediaImage: UIImageView = {
        let mediaImage = UIImageView()
        
        mediaImage.layer.masksToBounds = true
        mediaImage.layer.cornerRadius = 8.0
        
        mediaImage.image = UIImage(systemName: "photo")
        mediaImage.contentMode = .scaleAspectFill
        return mediaImage
    }()
    
//    private let likeButton: UIButton = {
//        let likeButton = UIButton()
//        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        likeButton.tintColor = UIColor().qBlack
//        likeButton.backgroundColor = UIColor().qPurple
//        likeButton.layer.cornerRadius = 8.0
//        likeButton.layer.masksToBounds = true
//        return likeButton
//    }()
//    
//    private let dislikeButton: UIButton = {
//        let likeButton = UIButton()
//        likeButton.setImage(UIImage(systemName: "heart.slash"), for: .normal)
//        likeButton.tintColor = UIColor().qBlack
//        likeButton.backgroundColor = UIColor().qPurple
//        likeButton.layer.cornerRadius = 8.0
//        likeButton.layer.masksToBounds = true
//        return likeButton
//    }()
//    
//    private let commentButton: UIButton = {
//        let likeButton = UIButton()
//        likeButton.setImage(UIImage(systemName: "bubble.right"), for: .normal)
//        likeButton.tintColor = UIColor().qBlack
//        likeButton.backgroundColor = UIColor().qPurple
//        likeButton.layer.cornerRadius = 8.0
//        likeButton.layer.masksToBounds = true
//        return likeButton
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor().qBlack
        
        contentView.addSubview(userName)
        contentView.addSubview(postTitle)
        contentView.addSubview(postDescription)
        contentView.addSubview(postRating)
        contentView.addSubview(postDate)
        contentView.addSubview(mediaImage)
        contentView.addSubview(mediaName)
        contentView.addSubview(mediaOwner)
        
//        contentView.addSubview(likeButton)
//        contentView.addSubview(dislikeButton)
//        contentView.addSubview(commentButton)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor().qPurple.cgColor
        contentView.layer.masksToBounds = true
        
        super.layoutSubviews()
        
        userName.sizeToFit()
        postTitle.sizeToFit()
        postDescription.sizeToFit()
        postRating.sizeToFit()
        postDate.sizeToFit()
        mediaImage.sizeToFit()
        mediaName.sizeToFit()
        mediaOwner.sizeToFit()
        
        userName.frame = CGRect(x:5, y:5, width: contentView.width, height: userName.height)
        postTitle.frame = CGRect(x:5, y: userName.bottom + 5, width: contentView.width, height: postTitle.height)
        postDescription.frame = CGRect(x:5, y: postTitle.bottom, width: contentView.width, height: postDescription.height)
        
        postDate.frame = CGRect(x: contentView.width - postDate.width - 5, y: 5, width: postDate.width, height: postDate.height)
        
        
        let imageSize = contentView.width / 3
        
        mediaImage.frame = CGRect(x:5, y: postDescription.bottom + 5, width: imageSize, height: imageSize)
        mediaName.frame = CGRect(x: mediaImage.right + ((contentView.width - mediaImage.right) - mediaName.width) / 2, y: postDescription.bottom + 5, width: mediaName.width, height: mediaName.height)
        mediaOwner.frame = CGRect(x: mediaImage.right + ((contentView.width - mediaImage.right) - mediaOwner.width) / 2, y: mediaName.bottom + 5, width: mediaOwner.width, height: mediaOwner.height)
        postRating.frame = CGRect(x: mediaImage.right + ((contentView.width - mediaImage.right) - postRating.width) / 2, y: mediaImage.bottom - postRating.height - 5, width: postRating.width, height: postRating.height)
        
        //let buttonSize = contentView.width / 8
        
//        likeButton.sizeToFit()
//        likeButton.frame = CGRect(x: 5, y: mediaImage.bottom + 10, width: contentView.width / 3 - 7.5, height: buttonSize)
//
//        commentButton.sizeToFit()
//        commentButton.frame = CGRect(x: contentView.right - (contentView.width / 3 - 7.5) - 5, y: mediaImage.bottom + 10, width: contentView.width / 3 - 7.5, height: buttonSize)
//
//
//        dislikeButton.sizeToFit()
//        dislikeButton.frame = CGRect(x: likeButton.right + 2.5, y: mediaImage.bottom + 10, width: commentButton.left - likeButton.right - 5, height: buttonSize)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userName.text = nil
        postTitle.text = nil
        postDate.text = nil
        postDescription.text = nil
        postRating.text = nil
        mediaImage.image = nil
        mediaName.text = nil
        mediaOwner.text = nil
        mediaName.frame = .zero
        mediaOwner.frame = .zero
    }
    
    func configure(viewModel: FeedPostCellViewModel) {
        userName.text = viewModel.user
        postTitle.text = viewModel.title
        
        postDate.text = viewModel.date
        postDescription.text = viewModel.description
        postRating.text = "Rated: \(viewModel.rating)/10"
        mediaImage.sd_setImage(with: URL(string: viewModel.media), completed: nil)
        
        switch (viewModel.type) {
        case "track":
            mediaName.text = viewModel.track
            mediaOwner.text = viewModel.artist
        case "album":
            mediaName.text = viewModel.album
            mediaOwner.text = viewModel.artist
        case "artist":
            mediaName.text = viewModel.artist
            mediaOwner.text = "the artist themselves."
        default:
            mediaName.text = ""
            mediaOwner.text = ""
        }
    }
}

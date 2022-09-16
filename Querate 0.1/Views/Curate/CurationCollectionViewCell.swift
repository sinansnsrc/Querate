//
//  CurateViewCell.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 5/30/22.
//

import Foundation
import UIKit

class CurationCollectionViewCell: UICollectionViewCell {
    static let identifier = "CurationCollectionViewCell"
    
    private let toolName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let toolDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor().qBlack
        
        contentView.addSubview(toolName)
        contentView.addSubview(toolDescription)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor().qRed.cgColor
        
        toolName.sizeToFit()
        toolDescription.sizeToFit()
        
        toolName.frame = CGRect(x: 5, y: 0, width: contentView.width, height: toolName.height)
        toolDescription.frame = CGRect(x: 5, y: toolName.bottom, width: contentView.width, height: contentView.height - toolName.bottom)
        
        //contentView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: toolDescription.bottom + 5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        toolName.text = nil
        toolDescription.text = nil
    }
    
    func configure(title: String, description: String, URL: URL) {
        toolName.text = title
        toolDescription.text = description
        //URL TBI
    }
}


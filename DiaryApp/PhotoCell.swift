//
//  PhotoCell.swift
//  DiaryApp
//
//  Created by Alexey Papin on 10.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "\(PhotoCell.self)"
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
}

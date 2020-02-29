//
//  MainViewCell.swift
//  PhotosMultiSelect
//
//  Created by Yasuyuki on 2020/02/27.
//  Copyright © 2020 grassrunners. All rights reserved.
//

import UIKit

class MainViewCell: UICollectionViewCell {
    
    private var thumbnailView: UIImageView!

    // MARK: init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setLayout()
        
    }
    
    // MARK: setLayout
    private func setLayout() {
        
        thumbnailView = UIImageView()
        thumbnailView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        thumbnailView.clipsToBounds = true
        thumbnailView.layer.cornerRadius = 2.5
        thumbnailView.contentMode = .scaleAspectFill
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(thumbnailView)

        thumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        thumbnailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        thumbnailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true

    }

    // MARK: required init
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")

    }
    
    // MARK: setValue
    func setValue(thumbnail: UIImage) {

        thumbnailView.image = thumbnail

    }
    
}

//
//  LibraryAlbumViewCell.swift
//  PhotosMultiSelect
//
//  Created by Yasuyuki on 2020/02/26.
//  Copyright © 2020 grassrunners. All rights reserved.
//

import UIKit

class LibraryAlbumViewCell: UITableViewCell {
    
    let cellThumbnailView1: UIImageView = {
        let obj = UIImageView()
        obj.contentMode = .scaleAspectFill
        obj.clipsToBounds = true
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()

    let cellThumbnailView3: UIImageView = {
        let obj = UIImageView()
        obj.contentMode = .scaleAspectFill
        obj.clipsToBounds = true
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()

    let cellThumbnailView5: UIImageView = {
        let obj = UIImageView()
        obj.contentMode = .scaleAspectFill
        obj.clipsToBounds = true
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    let cellWhiteView2: UIView = {
        let obj = UIView()
        obj.backgroundColor = UIColor.white
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()

    let cellWhiteView4: UIView = {
        let obj = UIView()
        obj.backgroundColor = UIColor.white
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()

    let cellNameLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = UIColor.black
        obj.font = .systemFont(ofSize: 16)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()

    let cellCountLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = UIColor.lightGray
        obj.font = .systemFont(ofSize: 16)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()

    // MARK: override init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }

    // MARK: required init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: setLayout
    func setLayout() {
        
        contentView.addSubview(cellThumbnailView5)
        contentView.addSubview(cellWhiteView4)
        contentView.addSubview(cellThumbnailView3)
        contentView.addSubview(cellWhiteView2)
        contentView.addSubview(cellThumbnailView1)
        contentView.addSubview(cellNameLabel)
        contentView.addSubview(cellCountLabel)

        cellThumbnailView1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        cellThumbnailView1.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        cellThumbnailView1.widthAnchor.constraint(equalToConstant: 72).isActive = true
        cellThumbnailView1.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        cellWhiteView2.centerXAnchor.constraint(equalTo: cellThumbnailView1.centerXAnchor, constant: 0).isActive = true
        cellWhiteView2.centerYAnchor.constraint(equalTo: cellThumbnailView1.centerYAnchor, constant: -0.5).isActive = true
        cellWhiteView2.widthAnchor.constraint(equalTo: cellThumbnailView1.widthAnchor, constant: 0).isActive = true
        cellWhiteView2.heightAnchor.constraint(equalTo: cellThumbnailView1.heightAnchor, constant: 0).isActive = true

        cellThumbnailView3.centerXAnchor.constraint(equalTo: cellThumbnailView1.centerXAnchor, constant: 0).isActive = true
        cellThumbnailView3.centerYAnchor.constraint(equalTo: cellThumbnailView1.centerYAnchor, constant: -4).isActive = true
        cellThumbnailView3.widthAnchor.constraint(equalToConstant: 68).isActive = true
        cellThumbnailView3.heightAnchor.constraint(equalToConstant: 68).isActive = true

        cellWhiteView4.centerXAnchor.constraint(equalTo: cellThumbnailView3.centerXAnchor, constant: 0).isActive = true
        cellWhiteView4.centerYAnchor.constraint(equalTo: cellThumbnailView3.centerYAnchor, constant: -0.5).isActive = true
        cellWhiteView4.widthAnchor.constraint(equalTo: cellThumbnailView3.widthAnchor, constant: 0).isActive = true
        cellWhiteView4.heightAnchor.constraint(equalTo: cellThumbnailView3.heightAnchor, constant: 0).isActive = true

        cellThumbnailView5.centerXAnchor.constraint(equalTo: cellThumbnailView3.centerXAnchor, constant: 0).isActive = true
        cellThumbnailView5.centerYAnchor.constraint(equalTo: cellThumbnailView3.centerYAnchor, constant: -4).isActive = true
        cellThumbnailView5.widthAnchor.constraint(equalToConstant: 64).isActive = true
        cellThumbnailView5.heightAnchor.constraint(equalToConstant: 64).isActive = true

        cellNameLabel.leadingAnchor.constraint(equalTo: cellThumbnailView1.trailingAnchor, constant: 16).isActive = true
        cellNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -11).isActive = true

        cellCountLabel.leadingAnchor.constraint(equalTo: cellThumbnailView1.trailingAnchor, constant: 16).isActive = true
        cellCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 11).isActive = true
    }
    
    // MARK: setValue
    func setValue(name: String, count: Int, images: [UIImage]) {
        
        cellNameLabel.text = name
        
        cellCountLabel.text = String(count)
        
        cellThumbnailView1.image = images[0]
        cellThumbnailView3.image = images[1]
        cellThumbnailView5.image = images[2]

    }
}

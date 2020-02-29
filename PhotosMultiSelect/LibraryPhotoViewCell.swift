//
//  LibraryPhotoViewCell.swift
//  PhotosMultiSelect
//
//  Created by Yasuyuki on 2020/02/26.
//  Copyright © 2020 grassrunners. All rights reserved.
//

import UIKit

class LibraryPhotoViewCell: UICollectionViewCell {
    
    let cellSide = (UIScreen.main.bounds.size.width - 1.5) / 3

    private let thumbnailView: UIImageView = {
        let obj = UIImageView()
        obj.contentMode = .scaleAspectFill
        obj.clipsToBounds = true
        obj.image = UIImage()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private var gradationView: UIView!

    private let durationLabel: UILabel = {
        let obj = UILabel()
        obj.font = .boldSystemFont(ofSize: 12)
        obj.textColor = UIColor.white
        obj.textAlignment = .right
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let outerCircle: UILabel = {
        let obj = UILabel()
        obj.clipsToBounds = true
        obj.layer.cornerRadius = 15.5
        obj.layer.borderWidth = 1
        obj.layer.borderColor = UIColor.lightGray.cgColor
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let innerCircle: UILabel = {
        let obj = UILabel()
        obj.clipsToBounds = true
        obj.layer.cornerRadius = 13.5
        obj.layer.borderWidth = 1
        obj.layer.borderColor = UIColor.lightGray.cgColor
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
        
    private let checkButton: UIButton = {
        let obj = UIButton()
        obj.clipsToBounds = true
        obj.layer.cornerRadius = 15
        obj.layer.borderWidth = 2
        obj.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7).cgColor
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let checkmarkView: UIView = {
        let obj = UIView()
        obj.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
        
    private let checkmarkLabel: UILabel = {
        let obj = UILabel()
        obj.text = "check"
        obj.font = UIFont(name: "FontAwesome5Free-Solid",size: 16)
        obj.textColor = UIColor.white
        obj.backgroundColor = UIColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1.0)
        obj.textAlignment = .center
        obj.clipsToBounds = true
        obj.layer.cornerRadius = 13
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()

    // MARK: override init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }

    // MARK: required init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: setLayout
    func setLayout() {
        
        gradationView = UIView()
        let topColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0)
        let bottomColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.9)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = CGRect(x: 0, y: 0, width: cellSide, height: 25)
        gradationView.layer.insertSublayer(gradientLayer, at: 0)
        gradationView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(thumbnailView)
        contentView.addSubview(gradationView)
        contentView.addSubview(durationLabel)
        contentView.addSubview(innerCircle)
        contentView.addSubview(outerCircle)
        contentView.addSubview(checkButton)

        thumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        thumbnailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        thumbnailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true

        gradationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        gradationView.widthAnchor.constraint(equalToConstant: 123).isActive = true
        gradationView.heightAnchor.constraint(equalToConstant: 25).isActive = true

        durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        durationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        
        innerCircle.centerXAnchor.constraint(equalTo: checkButton.centerXAnchor, constant: 0).isActive = true
        innerCircle.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor, constant: 0).isActive = true
        innerCircle.widthAnchor.constraint(equalToConstant: 27).isActive = true
        innerCircle.heightAnchor.constraint(equalToConstant: 27).isActive = true

        outerCircle.centerXAnchor.constraint(equalTo: checkButton.centerXAnchor, constant: 0).isActive = true
        outerCircle.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor, constant: 0).isActive = true
        outerCircle.widthAnchor.constraint(equalToConstant: 31).isActive = true
        outerCircle.heightAnchor.constraint(equalToConstant: 31).isActive = true

        checkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        checkButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        checkButton.addTarget(self, action: #selector(tapCheckButton(sender:)), for: .touchUpInside)
    }

    // MARK: setValue
    func setValue(thumbnail: UIImage, duration: String) {
        
        thumbnailView.image = thumbnail
        durationLabel.text = duration
        
        if duration == "" {
            
            gradationView.alpha = 0.0
        } else {
            
            gradationView.alpha = 1.0
        }

    }
    
    // MARK: tapCheckButton
    @objc private func tapCheckButton(sender: UIButton) {
        
        let collectionView = self.superview as! UICollectionView
        
        let libraryPhotoView = collectionView.delegate as! LibraryPhotoViewController

        let point = collectionView.convert(sender.frame.origin, from: sender.superview)

        if let indexPath = collectionView.indexPathForItem(at: point) {

            libraryPhotoView.toggleCheckMark(indexPath: indexPath)
        }
    }

    // MARK: isMarked
    var isMarked: Bool = false {

        didSet {
            
            if isMarked {
                
                contentView.addSubview(checkmarkView)
                checkmarkView.addSubview(checkmarkLabel)
                contentView.bringSubviewToFront(checkButton)
                
                checkmarkView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
                checkmarkView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
                checkmarkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
                checkmarkView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
                
                checkmarkLabel.centerXAnchor.constraint(equalTo: checkButton.centerXAnchor, constant: 0).isActive = true
                checkmarkLabel.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor, constant: 0).isActive = true
                checkmarkLabel.widthAnchor.constraint(equalToConstant: 26).isActive = true
                checkmarkLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
                
            } else {
                
                checkmarkView.removeFromSuperview()
            }
        }
    }

    // MARK: clearCheckmark
    func clearCheckmark() -> Void {

        self.isMarked = false
    }

}


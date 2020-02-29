//
//  LibraryPhotoViewHeader.swift
//  PhotosMultiSelect
//
//  Created by Yasuyuki on 2020/02/26.
//  Copyright © 2020 grassrunners. All rights reserved.
//

import UIKit

class LibraryPhotoViewHeader: UICollectionReusableView {
    
    var titleLabel: UILabel =  {
        let obj = UILabel()
        obj.font = .systemFont(ofSize: 16)
        obj.textColor = UIColor.darkGray
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let outerCircle: UILabel = {
        let obj = UILabel()
        obj.clipsToBounds = true
        obj.layer.cornerRadius = 15.5
        obj.layer.borderWidth = 1
        obj.layer.borderColor = UIColor.darkGray.cgColor
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private let innerCircle: UILabel = {
        let obj = UILabel()
        obj.clipsToBounds = true
        obj.layer.cornerRadius = 13.5
        obj.layer.borderWidth = 1
        obj.layer.borderColor = UIColor.darkGray.cgColor
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
        
    private let checkButton: UIButton = {
        let obj = UIButton()
        obj.clipsToBounds = true
        obj.layer.cornerRadius = 15
        obj.layer.borderWidth = 2
        obj.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
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
    
    // MARK: init
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setLayout()
    }
    
    // MARK: required init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: setLayout
    private func setLayout() {
        backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        
        addSubview(titleLabel)
        
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true

        addSubview(innerCircle)
        addSubview(outerCircle)
        addSubview(checkButton)
        
        innerCircle.centerXAnchor.constraint(equalTo: checkButton.centerXAnchor, constant: 0).isActive = true
        innerCircle.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor, constant: 0).isActive = true
        innerCircle.widthAnchor.constraint(equalToConstant: 27).isActive = true
        innerCircle.heightAnchor.constraint(equalToConstant: 27).isActive = true

        outerCircle.centerXAnchor.constraint(equalTo: checkButton.centerXAnchor, constant: 0).isActive = true
        outerCircle.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor, constant: 0).isActive = true
        outerCircle.widthAnchor.constraint(equalToConstant: 31).isActive = true
        outerCircle.heightAnchor.constraint(equalToConstant: 31).isActive = true

        checkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        checkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        checkButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        checkButton.addTarget(self, action: #selector(tapAllCheckButton(sender:)), for: .touchUpInside)

    }
    
    // MARK: setValue
    func setValue(titleText: String) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let titleTextDate: Date = formatter.date(from: titleText)!

        formatter.dateFormat = "yyyy"
        
        if formatter.string(from: titleTextDate) == formatter.string(from: Date()) {
            
            formatter.dateFormat = "M月d日"
        } else {
            
            formatter.dateFormat = "yyyy年M月d日"
        }
        
        let wdayFormat = DateFormatter()
        wdayFormat.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEEE", options: 0, locale: Locale.current)

        let dateStr = formatter.string(from: titleTextDate) + " " + wdayFormat.string(from: titleTextDate) + "曜日"

        titleLabel.text = dateStr
    }
    
    // MARK: tapAllCheckButton
    @objc private func tapAllCheckButton(sender: UIButton) {
        
        let collectionView = self.superview as! UICollectionView
        
        let libraryPhotoView = collectionView.delegate as! LibraryPhotoViewController

        let point = collectionView.convert(sender.frame.origin, from: sender.superview)
        
        let ajustedPoint = CGPoint(x: 0, y: point.y + 50)

        if let indexPath = collectionView.indexPathForItem(at: ajustedPoint) {
            
            let count = libraryPhotoView.cells[indexPath.section].count
            
            for i in 0...(count - 1) {
                
                let indexPathInSection = IndexPath(item: i, section: indexPath.section)
                
                if self.isMarked {
                    
                    libraryPhotoView.depriveCheckMark(indexPath: indexPathInSection)

                } else {
                    
                    libraryPhotoView.giveCheckMark(indexPath: indexPathInSection)
                }
                
                libraryPhotoView.displayMarkedItemsCount()
                
                libraryPhotoView.toolbarDisplayControl()
            }
            libraryPhotoView.checkAllItemsInSectionIsMarked(indexPath: indexPath)
        }
    }

    // MARK: isMarked
    var isMarked: Bool = false {

        didSet {
            
            if isMarked {
                
                addSubview(checkmarkLabel)
                bringSubviewToFront(checkButton)
                
                checkmarkLabel.centerXAnchor.constraint(equalTo: checkButton.centerXAnchor, constant: 0).isActive = true
                checkmarkLabel.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor, constant: 0).isActive = true
                checkmarkLabel.widthAnchor.constraint(equalToConstant: 26).isActive = true
                checkmarkLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
                
            } else {
                
                checkmarkLabel.removeFromSuperview()
            }
        }
    }
}

//
//  MainViewController.swift
//  PhotosMultiSelect
//
//  Created by Yasuyuki on 2020/02/25.
//  Copyright © 2020 grassrunners. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var items: [UIImage] = []
    var photoCollectionView: UICollectionView!
    
    // MARK: loadView
    override func loadView() {
        
        super.loadView()

        setLayout()

    }
    
    // MARK: setLayout
    private func setLayout() {
        
        let cellSide = (UIScreen.main.bounds.size.width - 1.5) / 3
        
        let navigationBarAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openPhotoLibrary))
        navigationItem.setRightBarButton(navigationBarAdd, animated: true)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellSide, height: cellSide)
        flowLayout.minimumInteritemSpacing = 0.5
        flowLayout.minimumLineSpacing = 0.5
        flowLayout.sectionInset = UIEdgeInsets(top: 0.5, left: 0, bottom: 50, right: 0.5)
        
        photoCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        photoCollectionView.backgroundColor = UIColor.white
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false

        photoCollectionView.register(MainViewCell.self, forCellWithReuseIdentifier: "Cell")
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        view.addSubview(photoCollectionView)

        photoCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        photoCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        photoCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        photoCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "メイン"

        view.backgroundColor = UIColor.white
        
    }
        
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        photoCollectionView.reloadData()
                
    }
        
    // MARK: openPhotoLibrary
    // フォトライブラリを起動
    @objc func openPhotoLibrary(_ sender: UIBarButtonItem) {
        
        let vc = UINavigationController(rootViewController: LibraryAlbumViewController())
        self.present(vc, animated: true, completion: nil)
        
    }

}

// MARK: UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {

    // MARK: didSelectItemAt
    // セルをタップしたときの処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

// MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {

    // MARK: numberOfSections
    // コレクションビューのセクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: numberOfItemsInSection
    // コレクションビューのアイテム数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
        
    // MARK: cellForItemAt
    // コレクションビューのセルごとの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath as IndexPath) as! MainViewCell
        cell.setValue(thumbnail: items[indexPath.item])
        
        return cell
    }
    
}

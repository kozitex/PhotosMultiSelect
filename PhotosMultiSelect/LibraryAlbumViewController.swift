//
//  LibAlbumViewController.swift
//  PhotosMultiSelect
//
//  Created by Yasuyuki on 2020/02/25.
//  Copyright © 2020 grassrunners. All rights reserved.
//

import UIKit
import Photos

class LibraryAlbumViewController: UIViewController {

    var tableView: UITableView!
    
    var navigationBarCancel = UIBarButtonItem()
    
    var data: [[(name: String, count: Int, images: [UIImage], collection: PHAssetCollection)]] = []
    
    let collectionTypes = [(type: PHAssetCollectionType.smartAlbum, name: ""), (type: PHAssetCollectionType.album, name: "マイアルバム")]

    let collectionSubTypes = [[PHAssetCollectionSubtype.smartAlbumUserLibrary, PHAssetCollectionSubtype.smartAlbumRecentlyAdded, PHAssetCollectionSubtype.smartAlbumFavorites, PHAssetCollectionSubtype.smartAlbumTimelapses, PHAssetCollectionSubtype.smartAlbumVideos, PHAssetCollectionSubtype.smartAlbumSelfPortraits, PHAssetCollectionSubtype.smartAlbumScreenshots], [PHAssetCollectionSubtype.albumRegular]]
    
    
    // MARK: loadView
    override func loadView() {
        
        super.loadView()
                
        setupData()
        
        setLayout()
        
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "写真"
    }
        
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    // MARK: setLayout
    private func setLayout() {
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(LibraryAlbumViewCell.self, forCellReuseIdentifier: "Cell")

        tableView.tableFooterView = UIView(frame: .zero)

        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

        navigationBarCancel = UIBarButtonItem(title: "キャンセル", style: .done, target: self, action: #selector(tapCancel(_:)))

        navigationItem.setRightBarButton(navigationBarCancel, animated: true)

    }
    
    // MARK: setupData
    private func setupData() {
        
        for i in 0...1 {

            let collectionType = collectionTypes[i].type
            
            var albumList: [(name: String, count: Int, images: [UIImage], collection: PHAssetCollection)] = []

            for collectionSubType in collectionSubTypes[i] {
                
                let collectionLists = getCollectionLists(collectionType: collectionType, collectionSubType: collectionSubType)
                
                for collectionList in collectionLists {
                    
                    albumList.append(collectionList)
                }
            }

            data.append(albumList)
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assets = PHAsset.fetchAssets(with: fetchOptions)

        let images = generateThumbnails(assets: assets)
        
        data[0].insert((name: "すべての写真", count: assets.count, images: images, collection: PHAssetCollection()), at: 0)
    }
    
    // MARK: getCollectionLists
    // フォトライブラリからアルバムのリストを取得
    private func getCollectionLists(collectionType: PHAssetCollectionType, collectionSubType: PHAssetCollectionSubtype) -> [(name: String, count: Int, images: [UIImage], collection: PHAssetCollection)] {
        
        let collectionData = PHAssetCollection.fetchAssetCollections(with: collectionType, subtype: collectionSubType, options: nil)

        var collectionList: [(name: String, count: Int, images: [UIImage], collection: PHAssetCollection)] = []

        collectionData.enumerateObjects { (collection, index, _) in

            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let assets = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            
            let name = collection.localizedTitle!
            let count = assets.count
            let images = self.generateThumbnails(assets: assets)

            if count > 0 {
                collectionList.append((name: name, count: count, images: images, collection: collection))
            }
        }

        return collectionList
    }

    // MARK: generateThumbnails
    // 指定したアルバムから最新3つの画像のサムネイルを返却
    private func generateThumbnails(assets: PHFetchResult<PHAsset>) -> [UIImage] {
        
        let imageManager = PHCachingImageManager()
        
        let scale = UIScreen.main.scale
        let cellSize: CGFloat = (UIScreen.main.bounds.size.height / 12) - 4
        let thumbnailSize = CGSize(width: cellSize * scale, height: cellSize * scale)

        var thumbnails: [UIImage] = []
        
        if assets.firstObject == nil { return [UIImage(), UIImage(), UIImage()] }
        
        var loopCount = 2
        
        if assets.count < 3 {
            
            loopCount = assets.count - 1
            
        }
        
        for i in 0...loopCount {
            
            let asset = assets.object(at: i)
                
            imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                
                thumbnails.append(image! as UIImage)
            })
        }
        
        if loopCount < 2 {
            
            for _ in 0...(1 - loopCount) {
                
                thumbnails.append(UIImage())
            }
        }
        
        return thumbnails
    }
    
    // MARK: tapCancel
    // 「キャンセル」ボタンをタップ
    @objc func tapCancel(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}

// MARK: UITableViewDataSource
extension LibraryAlbumViewController: UITableViewDataSource {

    
    // MARK: numberOfRowsInSection
    // セクションごとにデータ要素数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    // MARK: numberOfSections
    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return collectionTypes.count
    }

    // MARK: titleForHeaderInSection
    // セクションヘッダ
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
        return collectionTypes[section].name
    }

    // MARK: heightForRowAt
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    // MARK: cellForRowAt
    // セル生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LibraryAlbumViewCell
        
        let name = data[indexPath.section][indexPath.row].name
        let count = data[indexPath.section][indexPath.row].count
        let images = data[indexPath.section][indexPath.row].images

        cell.setValue(name: name, count: count, images: images)
        
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

// MARK: UITableViewDelegate
// セルタップ時の動作定義など
extension LibraryAlbumViewController: UITableViewDelegate {

    // MARK: heightForHeaderInSection
    // セクションヘッダの高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }

    // MARK: didSelectRowAt
    // セルタップ時の挙動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let libraryPhotoView = LibraryPhotoViewController()
        libraryPhotoView.viewTitle = data[indexPath.section][indexPath.row].name
        libraryPhotoView.collection = data[indexPath.section][indexPath.row].collection

        self.navigationController?.pushViewController(libraryPhotoView, animated: true)

    }
}

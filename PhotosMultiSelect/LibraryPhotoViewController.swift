//
//  LibraryPhotoViewController.swift
//  PhotosMultiSelect
//
//  Created by Yasuyuki on 2020/02/26.
//  Copyright © 2020 grassrunners. All rights reserved.
//

import UIKit
import Photos

class LibraryPhotoViewController: UIViewController {

    var collectionView: UICollectionView!
    
    var viewTitle: String = ""
    
    var collection: PHAssetCollection = PHAssetCollection()
    
    var navigationBarCancel = UIBarButtonItem()
    var navigationBarOk = UIBarButtonItem()
    var navigationBarFlexSpace = UIBarButtonItem()
    var navigationBarCountLabel = UIBarButtonItem()
    var navigationBarMessageLabel = UIBarButtonItem()
    var navigationBarClear = UIBarButtonItem()

    var sections: [[String]] = []
    var cells: [[(dateStr: String, index: Int)]] = []

    var assets: PHFetchResult<PHAsset> = PHFetchResult()
        
    let scale = UIScreen.main.scale
    let cellSize: CGFloat = (UIScreen.main.bounds.size.height / 12) - 4
    var thumbnailSize = CGSize()
    let imageManager = PHCachingImageManager()
    
    var items: [UIImage] = []

    let cellSide = (UIScreen.main.bounds.size.width - 1.5) / 3

    let markedCount: UILabel = {
        let obj = UILabel()
        obj.numberOfLines = 0
        obj.font = .boldSystemFont(ofSize: 20)
        obj.textColor = UIColor.darkGray
        obj.textAlignment = .right
        obj.frame = CGRect(x: 0, y: 0, width: 36, height: 18)
        return obj
    }()

    let markedMessage: UILabel = {
        let obj = UILabel()
        obj.text = " 個のアイテムを選択中"
        obj.font = .systemFont(ofSize: 12)
        obj.textColor = UIColor.gray
        return obj
    }()
    
    // MARK: loadView
    override func loadView() {
        super.loadView()

        self.title = viewTitle
        
        setLayout()
    }
    
    // MARK: setLayout
    private func setLayout() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellSide, height: cellSide)
        flowLayout.minimumInteritemSpacing = 0.5
        flowLayout.minimumLineSpacing = 0.5
        flowLayout.sectionInset = UIEdgeInsets(top: 0.5, left: 0, bottom: 50, right: 0.5)
        flowLayout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 50)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(LibraryPhotoViewCell.self, forCellWithReuseIdentifier: "Cell")

        collectionView.register(LibraryPhotoViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")

        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

        navigationBarCancel = UIBarButtonItem(title: "キャンセル", style: .done, target: self, action: #selector(tapCancel(_:)))
        navigationBarOk = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(tapOk(_:)))
        navigationBarClear = UIBarButtonItem(title: "クリア", style: .plain, target: self, action: #selector(tapClear(_:)))
        navigationBarFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        navigationBarCountLabel = UIBarButtonItem(customView: markedCount)
        navigationBarMessageLabel = UIBarButtonItem(customView: markedMessage)

        navigationItem.setRightBarButton(navigationBarCancel, animated: true)
        navigationController?.toolbar.tintColor = UIColor(red: 0/255, green: 102/255, blue: 255/255, alpha: 1.0)

        self.toolbarItems = [navigationBarCountLabel, navigationBarMessageLabel, navigationBarFlexSpace, navigationBarClear, navigationBarOk]
        navigationController?.setToolbarHidden(true, animated: true)

    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        
        self.collectionView.allowsMultipleSelection = true
        
    }
    
    // MARK: setValue
    private func setupData() {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        thumbnailSize = CGSize(width: cellSize * scale, height: cellSize * scale)

        if collection.localizedTitle == nil {

            assets = PHAsset.fetchAssets(with: fetchOptions)
            
        } else {

            assets = PHAsset.fetchAssets(in: collection, options: fetchOptions)
        }
        
        var assetIndex: [(dateStr: String, index: Int)] = []

        for i in 0 ... (assets.count - 1) {
            
            let asset = assets.object(at: i)
            
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.locale = Locale.current
            formatter.dateFormat = "yyyy-MM-dd"
            
            let dateStr = formatter.string(from: asset.creationDate!)

            sections.append([dateStr])
            assetIndex.append((dateStr: dateStr, index: i))
        }
        
        let orderedSet = NSOrderedSet(array: sections)
        sections = orderedSet.array as! [[String]]
        
        for section in sections {
            
            let sectionData: [(dateStr: String, index: Int)] = assetIndex.filter({$0.dateStr == section[0]})
            
            cells.append(sectionData)
            
        }
    }
    
    // MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        _ = scrollToBottom
    }
    
    // MARK: scrollToBottom
    // 一番下までスクロール（初回だけ実行）
    private lazy var scrollToBottom: ( () -> Void )? = {
      
        collectionView.scrollToItem(at: IndexPath(item: cells[sections.count - 1].count - 1, section: sections.count - 1), at: .bottom, animated: false)

        return nil
    }()

    // MARK: tapCancel
    // 「キャンセル」ボタンをタップ
    @objc func tapCancel(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: tapClear
    // 「クリア」ボタンをタップ
    @objc func tapClear(_ sender: UIBarButtonItem) {
        
        let indexPaths = collectionView.indexPathsForSelectedItems!
        
        indexPaths.forEach { indexPath in
            let cell: LibraryPhotoViewCell? = collectionView.cellForItem(at: indexPath) as? LibraryPhotoViewCell
            
            cell?.clearCheckmark()
            
            collectionView.deselectItem(at: indexPath, animated: false)
            
            checkAllItemsInSectionIsMarked(indexPath: indexPath)
        }
        
        toolbarDisplayControl()
        
    }
    
    // MARK: tapOk
    // 「決定」ボタンをタップ
    @objc func tapOk(_ sender: UIBarButtonItem) {
        
        var indexPaths = collectionView.indexPathsForSelectedItems!

        indexPaths.sort { $0 < $1 }

        for indexPath in indexPaths {

            let index = cells[indexPath.section][indexPath.item].index
            let asset = assets.object(at: index)

            imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                if image == nil {
                    print("managerError")
                } else {
                    self.items.append(image! as UIImage)
                }
            })

        }
        
        let preNC = self.presentingViewController  as! UINavigationController
        let mainView = preNC.viewControllers[preNC.viewControllers.count - 1] as! MainViewController
        
        mainView.items = self.items
        
        mainView.photoCollectionView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: generateDuration
    // ビデオの所要時間を生成
    func generateDuration(asset: PHAsset) -> String {

        let timeInterval = asset.duration

        if timeInterval == 0 {

            return ""

        } else {

            let min = Int(timeInterval / 60)
            let sec = Int(round(timeInterval.truncatingRemainder(dividingBy: 60)))

            return String(format: "%01d:%02d", min, sec)
        }
    }
    
}

// MARK: UICollectionViewDataSource
extension LibraryPhotoViewController: UICollectionViewDataSource {

    // MARK: numberOfSections
    // コレクションビューのセクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    // MARK: viewForSupplementaryElementOfKind
    // ヘッダーの設定
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! LibraryPhotoViewHeader
        
        let headerText = sections[indexPath.section][indexPath.item]
        header.setValue(titleText: headerText)
        
        
        let count = cells[indexPath.section].count
                
        for i in 0...(count - 1) {
                        
            if !collectionView.indexPathsForSelectedItems!.contains(IndexPath(item: i, section: indexPath.section)) {
                
                header.isMarked = false
                
                return header
            }
        }
        
        header.isMarked = true

        return header
    }

    // MARK: numberOfItemsInSection
    // コレクションビューのアイテム数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells[section].count
    }

    // MARK: cellForItemAt
    // コレクションビューのセルごとの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LibraryPhotoViewCell

        let index = cells[indexPath.section][indexPath.item].index
        
        let asset = assets.object(at: index)
        
        let duration = generateDuration(asset: asset)

        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in

            if image != nil {

                cell.setValue(thumbnail: image!, duration: duration)
            }
        })
        
        if collectionView.indexPathsForSelectedItems!.contains(indexPath) {

            cell.isMarked = true
            
        } else {
            
            cell.isMarked = false
        }
        
        return cell
    }
}


// MARK: UICollectionViewDelegate
extension LibraryPhotoViewController: UICollectionViewDelegate {
    
    // MARK: didSelectItemAt
    // セルタップ時の挙動
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)

    }
    
    // MARK: didDeselectItemAt
    // セルタップで選択解除
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        
    }
    
    // MARK: toggleCheckMark
    func toggleCheckMark(indexPath: IndexPath) {

        guard let cell: LibraryPhotoViewCell = collectionView.cellForItem(at: indexPath) as? LibraryPhotoViewCell else { return }

        if cell.isMarked {
            
            depriveCheckMark(indexPath: indexPath)
            
        } else {
            
            giveCheckMark(indexPath: indexPath)
            
        }
        
        displayMarkedItemsCount()
                
        toolbarDisplayControl()
        
        checkAllItemsInSectionIsMarked(indexPath: indexPath)
        
    }
    
    // MARK: giveCheckMark
    // チェックマークをつける
    func giveCheckMark(indexPath: IndexPath) {

        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])

        guard let cell: LibraryPhotoViewCell = collectionView.cellForItem(at: indexPath) as? LibraryPhotoViewCell else { return }

        cell.isMarked = true

        var indexPaths = collectionView.indexPathsForSelectedItems!
        
        indexPaths.sort{$0 < $1}
        
    }
    
    // MARK: depriveCheckMark
    // チェックマークを外す
    func depriveCheckMark(indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let cell: LibraryPhotoViewCell = collectionView.cellForItem(at: indexPath) as? LibraryPhotoViewCell else { return }

        cell.isMarked = false

        var indexPaths = collectionView.indexPathsForSelectedItems!
        
        indexPaths.sort{$0 < $1}
        
    }
    
    // MARK: displayMarkedItemsCount
    // 選択中のアイテムの個数を表示
    func displayMarkedItemsCount() {
        
        let numberOfSelectedItems: Int? = collectionView.indexPathsForSelectedItems?.count
        
        markedCount.text = "\(numberOfSelectedItems!)"
    }
    
    // MARK: toolbarDisplayControl
    // ツールバーの表示・非表示を制御
    func toolbarDisplayControl() {
        
        let contentHeight = collectionView.contentSize.height
        let offsetY = collectionView.contentOffset.y
        let screenHeight = UIScreen.main.bounds.size.height

        let numberOfSelectedItems: Int? = collectionView.indexPathsForSelectedItems?.count
        
        if numberOfSelectedItems == 0 {

            navigationController?.setToolbarHidden(true, animated: true)
            
            if contentHeight - (offsetY + screenHeight) == -40 {

                collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentOffset.y - 50), animated: true)
            }
            
        } else if numberOfSelectedItems == 1 {
            
            navigationController?.setToolbarHidden(false, animated: true)

            if contentHeight - (offsetY + screenHeight) == 10 {
                
                collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentOffset.y + 50), animated: true)
            }
        }
    }
    
    // MARK: checkAllItemsInSectionIsMarked
    // セクション内の全アイテムが選択されているかをチェック
    func checkAllItemsInSectionIsMarked(indexPath: IndexPath) {
        
        guard let header: LibraryPhotoViewHeader = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: indexPath.section)) as? LibraryPhotoViewHeader else { return }
          
        let count = cells[indexPath.section].count
        
        for i in 0...(count - 1) {
            
            if !collectionView.indexPathsForSelectedItems!.contains(IndexPath(item: i, section: indexPath.section)) {
                
                header.isMarked = false

                return
            }
        }

        header.isMarked = true
    }
}

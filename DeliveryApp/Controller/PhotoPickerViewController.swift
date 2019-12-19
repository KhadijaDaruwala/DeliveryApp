//
//  PhotoPickerViewController.swift
//  DeliveryApp
//
//  Created by Khadija Daruwala on 19/12/19.
//  Copyright © 2019 Khadija Daruwala. All rights reserved.
//

import UIKit
import Photos

class PhotoPickerViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var fetchResult: PHFetchResult<PHAsset>!
    fileprivate let imageCellIdetifier = "ImageCollectionViewCell"
    fileprivate var cellSize : CGSize!
    fileprivate var selectedCellPaths = Set<IndexPath>()
    var imageAray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.includeAssetSourceTypes = .typeUserLibrary
        
        fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(buttonDoneClicked))
        self.navigationItem.rightBarButtonItem = done
    }
    
    static func loadFromNib() -> PhotoPickerViewController {
        return PhotoPickerViewController(nibName: "PhotoPickerViewController",
                                         bundle: nil)
    }
    
    @objc func buttonDoneClicked(){
        print(selectedCellPaths)
        
        for indexpath in selectedCellPaths{
            
            let phAssest = fetchResult[indexpath.item]
            let image = getAsset(phAssest)
            imageAray.append(image)
        }
        let vc = DisplayImageViewController.loadFromNib()
        vc.imageArray = imageAray
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    /*
     * From an asset to a UIImage, also can be used for thumbnail (if you change the :targetSize:)
     */
    func getAsset(_ asset: PHAsset) -> UIImage {
        
        var thumbnail = UIImage()
        //var imageData = Data()
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = false
        
        PHImageManager.default().requestImage(for: asset, targetSize: view.frame.size, contentMode: .aspectFill, options: options) { image, info in
            
            //thumbnail = image!
            if let image = image{
                thumbnail = image
            }
        }
        //You can check if the UIImage is nil. If it is nil is an iCloud image
        return thumbnail
        //return imageData
    }
    
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(UINib(nibName: imageCellIdetifier, bundle: nil), forCellWithReuseIdentifier: imageCellIdetifier)
        collectionView.backgroundColor = UIColor.white
    }
}

extension PhotoPickerViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdetifier, for: indexPath) as! ImageCollectionViewCell
        
        let phAssest = fetchResult[indexPath.item]
        let image = getAsset(phAssest)
        cell.photo = image
        if selectedCellPaths.contains(indexPath){
            cell.imageDisplay.alpha = 0.5
            cell.selectedImgView.isHidden = false
        } else {
            cell.imageDisplay.alpha = 1.0
            cell.selectedImgView.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Determine the cell size
        let itemsPerRow: CGFloat = 3.0
        let availableWidth = collectionView.frame.width
        let widthPerItem = availableWidth / itemsPerRow
        let cellSize = CGSize(width: widthPerItem, height:widthPerItem)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdetifier, for: indexPath) as! ImageCollectionViewCell
        if selectedCellPaths.contains(indexPath){
            selectedCellPaths.remove(indexPath)
            cell.imageDisplay.alpha = 1.0
        } else {
            selectedCellPaths.insert(indexPath)
            cell.imageDisplay.alpha = 0.5
            
        }
        collectionView.reloadItems(at: [indexPath])
    }
}



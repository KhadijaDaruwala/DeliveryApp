//
//  DisplayImageViewController.swift
//  DeliveryApp
//
//  Created by Activ Health on 18/12/19.
//  Copyright © 2019 Khadija Daruwala. All rights reserved.
//

import UIKit

class DisplayImageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageArray:[UIImage] = [UIImage]()
    let imageCellIdetifier = "ImageCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
    }
    
    static func loadFromNib() -> DisplayImageViewController {
        return DisplayImageViewController(nibName: "DisplayImageViewController",
                                          bundle: nil)
    }
}

//MARK: Custom Methods
extension DisplayImageViewController{
    func setupCollection(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.register(UINib(nibName: imageCellIdetifier, bundle: nil), forCellWithReuseIdentifier: imageCellIdetifier)
        collectionView.backgroundColor = UIColor.white
    }
}

//MARK: Collection view delegate methods
extension DisplayImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdetifier, for: indexPath) as! ImageCollectionViewCell
        cell.imageDisplay.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat =  self.collectionView.frame.width - 10
        let cellHeight: CGFloat = 250
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform.identity
        }
    }
}


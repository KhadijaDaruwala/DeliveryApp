//
//  ImageCollectionViewCell.swift
//  DeliveryApp
//
//  Created by Khadija Daruwala on 18/12/19.
//  Copyright © 2019 Khadija Daruwala. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedImgView: UIImageView!
    @IBOutlet weak var imageDisplay: UIImageView!
    
    var representedAssetIdentifier: String!
    var cellIsSelected: Bool = false
    var photo: UIImage! {
        didSet {
            imageDisplay.image = photo
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        imageDisplay.layer.borderColor = UIColor.gray.cgColor
        imageDisplay.layer.borderWidth = 1
    }
}

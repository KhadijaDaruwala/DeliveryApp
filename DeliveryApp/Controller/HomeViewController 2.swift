//
//  HomeViewController.swift
//  DeliveryApp
//
//  Created by Khadija Daruwala on 17/12/19.
//  Copyright © 2019 Khadija Daruwala. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Photos

class HomeViewController: UIViewController {
    
    //MARK:Class Properties
    let locationManager = CLLocationManager()
    let imagePicker = UIImagePickerController()
    var displayImageArray = [UIImage]()
    
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonPhoto: UIButton!
    @IBOutlet weak var buttonSignature: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
    }
    
    static func loadFromNib() -> HomeViewController {
        return HomeViewController(nibName: "HomeViewController",
                                  bundle: nil)
    }
}

//MARK: Button Actions
extension HomeViewController{
    @IBAction func buttonPhotoClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Upload File", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,  handler: { _ in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func buttonSignatureClicked(_ sender: Any) {
        let signatureVc = SignatureViewController.loadFromNib()
        self.navigationController?.pushViewController(signatureVc, animated: true)
    }
}


//MARK: Custom Methods
extension HomeViewController{
    func openCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            self.showToast(message:  AlertMessages.cameraError.value)
        }
    }
    
    func openGallery() {
        let albumName = "Album Name Here"
        var assetCollection = PHAssetCollection()
        var albumFound = Bool()
        var photoAssets = PHFetchResult<AnyObject>()
        let fetchOptions = PHFetchOptions()

        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

        if let firstObject = collection.firstObject{
            //found the album
            assetCollection = firstObject
            albumFound = true
        }
        else { albumFound = false }
        _ = collection.count
        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
        let imageManager = PHCachingImageManager()
        photoAssets.enumerateObjects{(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in

            if object is PHAsset{
                let asset = object as! PHAsset
                print("Inside  If object is PHAsset, This is number 1")

                let imageSize = CGSize(width: asset.pixelWidth,
                                       height: asset.pixelHeight)

                /* For faster performance, and maybe degraded image */
                let options = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                options.isSynchronous = true

                imageManager.requestImage(for: asset,
                                                  targetSize: imageSize,
                                                  contentMode: .aspectFill,
                                                  options: options,
                                                  resultHandler: {
                                                    (image, info) -> Void in
                                                    ///self.photo = image!
                                                    /* The image is now available to us */
                                                    self.addImgToArray(uploadImage: image!)
                                                    print("enum for image, This is number 2")

                })

            }
        }
    }
    
    func addImgToArray(uploadImage: UIImage) {
        self.displayImageArray.append(uploadImage)
    }
}

//MARK: Location and Map delegate methods
extension HomeViewController: CLLocationManagerDelegate, MKMapViewDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        mapView.mapType = MKMapType.standard
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        mapView.addAnnotation(annotation)
        
    }
}


//MARK: Image picker delegate methods
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.async {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                self.displayImageArray.append(image)
                let displayImageVc = DisplayImageViewController.loadFromNib()
                displayImageVc.imageArray = self.displayImageArray
                self.navigationController?.pushViewController(displayImageVc, animated: true)
            } else{
                self.showToast(message: AlertMessages.imageCaptureError.value)
            }
            
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            self.showToast(message: error.localizedDescription)
        } else {
            self.showToast(message: AlertMessages.imageSaved.value)
        }
    }
}

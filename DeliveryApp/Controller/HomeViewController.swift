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
    
    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonPhoto: SubmitButton!
    @IBOutlet weak var buttonSignature: SubmitButton!
    
    //MARK:Class Properties
      let locationManager = CLLocationManager()
      let imagePicker = UIImagePickerController()
      var displayImageArray = [UIImage]()
     
      //+Bonus task
      fileprivate var locationArray = [CLLocation]()
      fileprivate var newLocation : CLLocation?
      fileprivate var timer = Timer()
      //-Bonus task
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        self.title = "Map"
    }
    
    static func loadFromNib() -> HomeViewController {
        return HomeViewController(nibName: "HomeViewController",
                                  bundle: nil)
    }
    
    private func initialSetUp(){
        
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
         
         //+Bonus
         timer = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(timerAddLocationAction), userInfo: nil, repeats: true)
         mapView.showsUserLocation = true
         //-Bonus
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
        let photosVc = PhotoPickerViewController.loadFromNib()
        self.navigationController?.pushViewController(photosVc, animated: true)
    }
    
    func addImgToArray(uploadImage: UIImage) {
        self.displayImageArray.append(uploadImage)
    }
    
    //+Bonus
    @objc func timerAddLocationAction() {
        if let location = newLocation {
            if locationArray.count == 0 {
                locationArray.append(location)
            }
            else {
                //Measuring my distance in meter
                let distance = locationArray.last!.distance(from: location)
                print(distance)
                // if distance more then 1000 meter then reject that location(irregualr)
                if distance <= 1000 && distance >= 1 {
                    locationArray.append(location)
                }
            }
        }
        drawPath()
    }
    
    func drawPath() {
        // Remove old overlays
        mapView.removeOverlays(mapView.overlays)
        
        // Add new overlays
        var coordinates = [CLLocationCoordinate2D]()
        for loc in locationArray {
            coordinates.append(loc.coordinate)
        }
        let routeLine = MKPolyline(coordinates: coordinates, count: locationArray.count)
        mapView.addOverlay(routeLine)
        
        addAnnotation()
    }
    
    func addAnnotation() {
        // Remove old annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Add new annotations
        for location in locationArray {
            let locValue:CLLocationCoordinate2D = location.coordinate
            let annotation = MKPointAnnotation()
            annotation.coordinate = locValue
            mapView.addAnnotation(annotation)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: 2.0, longitudinalMeters: 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    //-Bonus
}

//MARK: Location and Map delegate methods
extension HomeViewController: CLLocationManagerDelegate, MKMapViewDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //+Bonus task
        if (locations.last != nil) && (locationArray.count == 0)
        {
            locationArray.append(locations.last!)
            addAnnotation()
            centerMapOnLocation(location: locations.last!)
        }
        newLocation = locations.last
        //-Bonus task
    }
    //+Bonus task
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: polyline)
            polylineRenderer.strokeColor = .green
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    //-Bonus task
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

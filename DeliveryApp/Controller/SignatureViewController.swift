//
//  SignatureViewController.swift
//  DeliveryApp
//
//  Created by Khadija Daruwala on 17/12/19.
//  Copyright © 2019 Khadija Daruwala. All rights reserved.
//

import UIKit

class SignatureViewController: UIViewController {
    
    @IBOutlet weak var viewSignature: DrawSignatureView!
    @IBOutlet weak var buttonClear: SubmitButton!
    @IBOutlet weak var buttonSave: SubmitButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSignature.delegate = self
        self.title = "eSignature"
    }
    
    static func loadFromNib() -> SignatureViewController {
        return SignatureViewController(nibName: "SignatureViewController",
                                       bundle: nil)
    }
}

//MARK: Button Actions
extension SignatureViewController{
    @IBAction func buttonClearClicked(_ sender: UIButton) {
        self.viewSignature.clear()
    }
    
    @IBAction func buttonSaveClicked(_ sender: UIButton) {
        if let signatureImage = self.viewSignature.getSignature(scale: 10) {
            UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
            self.viewSignature.clear()
        }
    }
}

//MARK: Signature delegate methods
extension SignatureViewController: DrawSignatureDelegate{
    func didStart(_ view : DrawSignatureView) {
        print("Started Drawing")
    }

    func didFinish(_ view : DrawSignatureView) {
        print("Finished Drawing")
    }
}

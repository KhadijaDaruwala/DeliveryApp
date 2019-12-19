//
//  AlertMessages.swift
//  DeliveryApp
//
//  Created by Khadija Daruwala on 18/12/19.
//  Copyright © 2019 Khadija Daruwala. All rights reserved.
//

import Foundation


enum AlertMessages : String{
    case errorTitle = "Error!"
    case successTitle = "Success!"
    case somethingWrongError = "Some technical issue, please check back later"
    case loactionSelectionError = "Some technical error while detecting your current location"
    case cameraError = "You do not have access to camera"
    case imageCaptureError = "Unable to save captured image"
    case imageSaved = "Your altered image has been saved to your photos."
    
    var value: String {
        return self.rawValue
    }
}


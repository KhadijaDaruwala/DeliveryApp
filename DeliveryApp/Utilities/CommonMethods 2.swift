//
//  CommonMethods.swift
//  DeliveryApp
//
//  Created by Khadija Daruwala on 17/12/19.
//  Copyright © 2019 Khadija Daruwala. All rights reserved.
//

import Foundation
import  UIKit


class CommonMethods {
    static let appDelegateInstance = UIApplication.shared.delegate as! AppDelegate
    
    static func setRootViewController(rootController: UIViewController) {
        CommonMethods.appDelegateInstance.window = UIWindow(frame: UIScreen.main.bounds)
        CommonMethods.appDelegateInstance.window?.rootViewController = UINavigationController(rootViewController: rootController)
        CommonMethods.appDelegateInstance.window?.makeKeyAndVisible()
    }
    
}

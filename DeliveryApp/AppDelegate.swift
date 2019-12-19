//
//  AppDelegate.swift
//  DeliveryApp
//
//  Created by Khadija Daruwala on 17/12/19.
//  Copyright © 2019 Khadija Daruwala. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainViewController = HomeViewController.loadFromNib()
        CommonMethods.setRootViewController(rootController: mainViewController)
        return true
    }
}


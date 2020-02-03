//
//  AppDelegate.swift
//  JADCommonTools
//
//  Created by iOS on 2019/12/30.
//  Copyright © 2019 LiXuan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        JADLanguage.initialize(defaultLanguage: nil)
        return true
    }

}


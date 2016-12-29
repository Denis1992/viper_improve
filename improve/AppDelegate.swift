//
//  AppDelegate.swift
//  improve
//
//  Created by Denis Bezrukov on 12.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import UIKit
import Swinject


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        DatabaseManager.prepare()
        let rootModule = RootModule.initializer()

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        guard let rootViewController = rootModule.view else { return true }
        self.window?.rootViewController = rootViewController
        
        self.window?.makeKeyAndVisible()

        return true
    }
}



//
//  AppDelegate.swift
//  Example
//
//  Created by Nora Trapp on 3/15/15.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        window?.rootViewController = ExampleViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

}


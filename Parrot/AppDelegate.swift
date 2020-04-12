//
//  AppDelegate.swift
//  Parrot
//
//  Created by Const. on 13.02.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var orientationLock = UIInterfaceOrientationMask.all

     func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
        
        
        
    }

    var window: UIWindow?
    var navigationController: UINavigationController?
    
    // MARK: - Application lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        
        navigationController = UINavigationController(rootViewController: ChannelsViewController())
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .systemYellow
        window?.rootViewController = navigationController
        return true
    }

}

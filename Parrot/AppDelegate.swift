//
//  AppDelegate.swift
//  Parrot
//
//  Created by Const. on 13.02.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    // MARK: - Application lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if SHOWLIFECYCLE
        print("Application moved from <Not running> to <Inactive>")
        print(#function + "\n")
        #endif
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        #if SHOWLIFECYCLE
        print("Application moved from <Inactive> to <Active>")
        print(#function + "\n")
        #endif
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        #if SHOWLIFECYCLE
        print("Application will move from <Active> to <Inactive>")
        print(#function + "\n")
        #endif
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        #if SHOWLIFECYCLE
        print("Application moved from <Inactive> to <Background>")
        print(#function + "\n")
        #endif
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        #if SHOWLIFECYCLE
        print("Application will move from <Background> to <Inactive>")
        print(#function + "\n")
        #endif
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        #if SHOWLIFECYCLE
        print("Application will move from <Suspended> to <Not running>")
        print(#function + "\n")
        #endif
    }
    
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Parrot")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


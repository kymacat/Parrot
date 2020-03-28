//
//  AppDelegate.swift
//  Parrot
//
//  Created by Const. on 13.02.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var orientationLock = UIInterfaceOrientationMask.all

     func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
        
        
        
    }

    var window: UIWindow?
    
    // MARK: - Application lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.black
            
        FirebaseApp.configure()
        
        
        let manager = CoreDataFileManager()
        
        
        // Извление записей
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileInformation")
        do {
            let results = try manager.managedObjectContext.fetch(fetchRequest)
            if results.count == 0 {
                if let entityDescription = NSEntityDescription.entity(forEntityName: "ProfileInformation", in: manager.managedObjectContext) {
                    
                    let managedObject = NSManagedObject(entity: entityDescription, insertInto: manager.managedObjectContext)
                    managedObject.setValue("Влад", forKey: "name")
                    managedObject.setValue("Люблю программировать под iOS, изучать что-то новое и не стоять на месте", forKey: "userDescription")
                    if let imageData = UIImage(named: "placeholder-user")?.pngData() {
                        managedObject.setValue(imageData, forKey: "imageData")
                    }
                    manager.saveContext()
                    
                    
                    
                }
                
            } else {
                for result in results as! [NSManagedObject] {
                    print("name - \(result.value(forKey: "name")!)")
                    print("userDescription - \(result.value(forKey: "userDescription")!)")
                    print("imageData - \(result.value(forKey: "imageData")!)")
                }
            }
        } catch {
            print(error)
        }
        
        return true
    }

}

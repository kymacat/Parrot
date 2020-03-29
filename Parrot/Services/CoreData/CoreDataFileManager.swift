//
//  CoreDataFileManager.swift
//  Parrot
//
//  Created by Const. on 28.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit
import CoreData


protocol ProfileFileManager {
    func getData() -> (name: String, description: String, image: Data)
    func saveData(name: String, description: String, image: UIImage)
}


class CoreDataFileManager : ProfileFileManager {
    
    private var info: ProfileInformation?
    
    init() {
        let _ = getData()
    }
    
    func getData() -> (name: String, description: String, image: Data) {
        if let userInfo = info {
            return (userInfo.name, userInfo.userDescription, userInfo.imageData)
        } else {
            request()
            if let infoAfterReq = info {
                return (infoAfterReq.name, infoAfterReq.userDescription, infoAfterReq.imageData)
            }
        }
        return ("", "", Data())
    }
    
    private func request() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileInformation")
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.count == 0 {
                if let entityDescription = NSEntityDescription.entity(forEntityName: "ProfileInformation", in: managedObjectContext) {
                    
                    let managedObject = ProfileInformation(entity: entityDescription, insertInto: managedObjectContext)
                    managedObject.name = "Влад Яндола"
                    managedObject.userDescription = "Люблю программировать под iOS, изучать что-то новое и не стоять на месте"
                    if let imageData = UIImage(named: "placeholder-user")?.pngData() {
                        managedObject.imageData = imageData
                    }
                    self.info = managedObject
                    saveContext()
                }
                
            } else {
                if let userInfo = results.first as? ProfileInformation {
                    self.info = userInfo
                }
            }
            
        } catch {
            print(error)
        }
    }
    
    func saveData(name: String, description: String, image: UIImage) {
        if let userInfo = info {
            userInfo.name = name
            userInfo.userDescription = description
            if let data = image.pngData() {
                userInfo.imageData = data
            }
            saveContext()
        }
        
    }
    

    // MARK: - Core Data stack
    
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "Parrot", withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }

        return managedObjectModel
    }()
    
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let fileManager = FileManager.default
        let storeName = "\("Parrot").sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }

        return persistentStoreCoordinator
    }()

    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            managedObjectContext.perform {
                do {
                    //Эмуляция долгого сохранения
                    sleep(2)
                    //
                    try self.managedObjectContext.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
            
        }
    }
    
}

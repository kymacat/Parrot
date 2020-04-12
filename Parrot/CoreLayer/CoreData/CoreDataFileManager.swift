//
//  CoreDataFileManager.swift
//  Parrot
//
//  Created by Const. on 28.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//
import UIKit
import CoreData


protocol IProfileFileManager {
    func getProfileData() -> (name: String, description: String, image: Data)
    func saveProfileData(name: String, description: String, image: Data)
    func getNotificationObject() -> NSManagedObjectContext
}

protocol IChannelsFileManager {
    func getFetchResultsController() -> NSFetchedResultsController<Channel>
    func appendChannels(channels: [ChannelModel])
    func deleteChannels(channels: [ChannelModel])
    func editStatusOfChannels(channels: [ChannelModel])
}

class CoreDataFileManager {
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
                    try self.managedObjectContext.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
            
        }
    }
    
}

class ProfileFileManager : CoreDataFileManager, IProfileFileManager {
    private var info: ProfileInformation?
    
    func getProfileData() -> (name: String, description: String, image: Data) {
        if let userInfo = info {
            return (userInfo.name, userInfo.userDescription, userInfo.imageData)
        } else {
            let fetchRequest = NSFetchRequest<ProfileInformation>(entityName: "ProfileInformation")
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
                    if let userInfo = results.first {
                        self.info = userInfo
                    }
                }
                
            } catch {
                print(error)
            }
            if let infoAfterReq = info {
                return (infoAfterReq.name, infoAfterReq.userDescription, infoAfterReq.imageData)
            }
        }
        return ("", "", Data())
    }
    
    func saveProfileData(name: String, description: String, image: Data) {
        if let userInfo = info {
            userInfo.name = name
            userInfo.userDescription = description
            userInfo.imageData = image
            
            saveContext()
        }
        
    }
    
    func getNotificationObject() -> NSManagedObjectContext {
        return managedObjectContext
    }
}


class ChannelsFileManager : CoreDataFileManager, IChannelsFileManager {
    
    func getFetchResultsController() -> NSFetchedResultsController<Channel> {
        let fetchRequest = NSFetchRequest<Channel>(entityName: "Channel")
        let sortDescriptor = NSSortDescriptor(key: "activeDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController<Channel>(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "isActive", cacheName: nil)
    }
    
    func appendChannels(channels: [ChannelModel]) {
        if let entityDescription = NSEntityDescription.entity(forEntityName: "Channel", in: managedObjectContext) {
            
            for channel in channels {
                let managedObject = Channel(entity: entityDescription, insertInto: managedObjectContext)
                managedObject.name = channel.name
                managedObject.activeDate = channel.activeDate
                managedObject.identifier = channel.identifier
                managedObject.isActive = channel.isActive
                managedObject.lastMessage = channel.lastMessage
                
            }
            saveContext()
        }
    }
    
    func deleteChannels(channels: [ChannelModel]) {
        let fetchRequest = NSFetchRequest<Channel>(entityName: "Channel")
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            for channel in channels {
                for result in results {
                    if channel.identifier == result.identifier {
                        managedObjectContext.delete(result)
                    }
                }
            }
            saveContext()
            
        } catch {
            print(error)
        }
    }
    
    func editStatusOfChannels(channels: [ChannelModel]) {
        let fetchRequest = NSFetchRequest<Channel>(entityName: "Channel")
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            for channel in channels {
                for result in results {
                    if channel.identifier == result.identifier {
                        if let date = channel.activeDate {
                            if (date < Date() - (60*10)) && channel.isActive {
                                result.isActive = false
                            }
                            if (date > Date() - (60*10)) && !channel.isActive {
                                result.isActive = true
                            }
                            if let secondDate = result.activeDate {
                                if date != secondDate {
                                    result.activeDate = channel.activeDate
                                }
                            } else {
                                result.activeDate = channel.activeDate
                            }
                            
                        }
                        if channel.lastMessage != result.lastMessage {
                            result.lastMessage = channel.lastMessage
                        }
                    }
                }
            }
            saveContext()
            
        } catch {
            print(error)
        }
    }
}

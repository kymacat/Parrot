//
//  ProfileService.swift
//  Parrot
//
//  Created by Const. on 12.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol IProfileService {
    func getUserData() -> (name: String, description: String, image: Data)
    func saveUserData(name: String, description: String, image: UIImage)
    func getNotificationObject() -> NSManagedObjectContext
    func saveImage(image: UIImage)
}

class ProfileService: IProfileService {
    
    let dataManager: IProfileFileManager
    
    init(dataManager: IProfileFileManager) {
        self.dataManager = dataManager
    }
    
    func getUserData() -> (name: String, description: String, image: Data) {
        return dataManager.getProfileData()
    }
    
    func saveUserData(name: String, description: String, image: UIImage) {
        if let data = image.pngData() {
            dataManager.saveProfileData(name: name, description: description, image: data)
        }
        
    }
    
    func saveImage(image: UIImage) {
        if let data = image.pngData() {
            dataManager.saveProfileImage(image: data)
        }
    }
    
    func getNotificationObject() -> NSManagedObjectContext {
        return dataManager.getNotificationObject()
    }
}

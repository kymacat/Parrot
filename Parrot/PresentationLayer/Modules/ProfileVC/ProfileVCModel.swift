//
//  ProfileVCModel.swift
//  Parrot
//
//  Created by Const. on 12.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit
import CoreData

protocol IProfileVCModel {
    func getUserData() -> (name: String, description: String, image: Data)
    func saveUserData(name: String, description: String, image: UIImage)
    func getNotificationObject() -> NSManagedObjectContext
}

class ProfileVCModel : IProfileVCModel {
    let profileService: IProfileService
    
    init(profileService: IProfileService) {
        self.profileService = profileService
    }
    
    func getUserData() -> (name: String, description: String, image: Data) {
        return profileService.getUserData()
    }
    
    func saveUserData(name: String, description: String, image: UIImage) {
        profileService.saveUserData(name: name, description: description, image: image)
    }
    
    func getNotificationObject() -> NSManagedObjectContext {
        return profileService.getNotificationObject()
    }
}

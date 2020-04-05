//
//  ProfileInformation+CoreDataProperties.swift
//  Parrot
//
//  Created by Const. on 29.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//
//

import Foundation
import CoreData


extension ProfileInformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileInformation> {
        return NSFetchRequest<ProfileInformation>(entityName: "ProfileInformation")
    }

    @NSManaged public var imageData: Data
    @NSManaged public var name: String
    @NSManaged public var userDescription: String

}

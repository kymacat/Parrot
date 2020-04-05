//
//  Message+CoreDataProperties.swift
//  Parrot
//
//  Created by Const. on 05.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var content: String
    @NSManaged public var created: Date
    @NSManaged public var senderID: String
    @NSManaged public var senderName: String
    @NSManaged public var channel: Channel

}

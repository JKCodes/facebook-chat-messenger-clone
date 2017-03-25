//
//  Message+CoreDataProperties.swift
//  FacebookMessengerClone
//
//  Created by Joseph Kim on 3/25/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var friend: Friend?

}

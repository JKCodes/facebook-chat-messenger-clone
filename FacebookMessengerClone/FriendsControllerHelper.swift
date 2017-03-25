//
//  FriendsControllerHelper.swift
//  FacebookMessengerClone
//
//  Created by Joseph Kim on 3/25/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit
import CoreData

extension FriendsController {

    func setupData() {
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.getContext() else { return }
        
        clearData(context: context)
        createData(context: context)
        loadData(context: context)
    }
    
    func clearData(context: NSManagedObjectContext) {
        do {
            let entityNames = ["Friend", "Message"]
            for entityName in entityNames {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

                if let objects = try context.fetch(fetchRequest) as? [NSManagedObject] {
                    for object in objects {
                        context.delete(object)
                    }
                }
            }
            
            
            try context.save()
        } catch let err {
            print("\(err)")
        }
    }
    
    func createData(context: NSManagedObjectContext) {
        let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "zuckprofile"
        
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = mark
        message.text = "Hello, my name is Mark. Nice to meet you..."
        message.date = NSDate()
        
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve_profile"
        
        let message2 = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message2.friend = steve
        message2.text = "Apple creates great iOS Devices for the world..."
        message2.date = NSDate()
        
        do {
            try context.save()
        } catch let err {
            print("\(err)")
        }
    }
    
    func loadData(context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        
        do {
            messages = try context.fetch(fetchRequest) as? [Message]
        } catch let err {
            print("\(err)")
        }
    }
    
}

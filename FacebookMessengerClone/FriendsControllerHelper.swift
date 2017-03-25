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
        
        createMessage(text: "Good morning...", friend: steve, minutesAgo: 5, context: context)
        createMessage(text: "Hello, how are you?", friend: steve, minutesAgo: 4, context: context)
        createMessage(text: "Do you have an Apple device?", friend: steve, minutesAgo: 3, context: context)
        createMessage(text: "Apple creates the best devices in the world.", friend: steve, minutesAgo: 2, context: context)
        
        let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        donald.name = "Donald Trump"
        donald.profileImageName = "donald_trump_profile"
        
        createMessage(text: "Hello, I am the the current president of the United States", friend: donald, minutesAgo: 6, context: context)
        
        do {
            try context.save()
        } catch let err {
            print("\(err)")
        }
    }
    
    private func createMessage(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
    }
    
    func loadData(context: NSManagedObjectContext) {
        
        if let friends = fetchFriends(context: context) {
            
            messages = [Message]()
            
            for friend in friends {
                guard let name = friend.name else { return }

                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "friend.name = %@", name)
                
                do {
                    if let fetchedMessages = try context.fetch(fetchRequest) as? [Message] {
                        messages?.append(contentsOf: fetchedMessages)
                    }
                } catch let err {
                    print("\(err)")
                }
            }
            
            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
        }
    }
    
    private func fetchFriends(context: NSManagedObjectContext) -> [Friend]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        
        do {
            return try context.fetch(request) as? [Friend]
        } catch let err {
            print("\(err)")
            return nil
        }
    }
    
}

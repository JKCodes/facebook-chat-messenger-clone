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
        
        createMarkMessages(context: context)
        createSteveMessages(context: context)
        createDonaldMessages(context: context)
        createGandhiMessages(context: context)
        createHillaryMessages(context: context)

        do {
            try context.save()
        } catch let err {
            print("\(err)")
        }
    }
    
    private func createMarkMessages(context: NSManagedObjectContext) {
        let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "zuckprofile"
        
        FriendsController.createMessage(text: "Hello, my name is Mark. Nice to meet you...", friend: mark, minutesAgo: 12, context: context)
        FriendsController.createMessage(text: "Do you like Facebook? It's the best thing in existence. It's so much better than sliced bread", friend: mark, minutesAgo: 10, context: context)
        FriendsController.createMessage(text: "I don't know about that. I like sliced bread better than Facebook", friend: mark, minutesAgo: 9, context: context, isSender: true)
        FriendsController.createMessage(text: "You should totally download the Facebook Messenger App along with your Facebook App.  It's so worth it", friend: mark, minutesAgo: 8, context: context)
        FriendsController.createMessage(text: "I haven't used Facebook in five years. Like what I said, I like sliced bread better.", friend: mark, minutesAgo: 7, context: context, isSender: true)
        FriendsController.createMessage(text: "Especially when it comes with peanut butter and jelly.  It's the best", friend: mark, minutesAgo: 6, context: context, isSender: true)
    }
    
    private func createSteveMessages(context: NSManagedObjectContext) {
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve_profile"
        
        FriendsController.createMessage(text: "Good morning...", friend: steve, minutesAgo: 57, context: context)
        FriendsController.createMessage(text: "Hello, how are you? Hope you are having a great day!", friend: steve, minutesAgo: 56, context: context)
        FriendsController.createMessage(text: "Would you like to make a purchase today?  I can give you a 92.1274663% discount on the iPhone 7 Plus, and it comes with a picture of my face engraved on the back of the phone", friend: steve, minutesAgo: 54, context: context)
        FriendsController.createMessage(text: "Hm.. 92% discount is very tempting... not sure about the picture though...", friend: steve, minutesAgo: 48, context: context, isSender: true)
        FriendsController.createMessage(text: "It's 92.1274663%... not 92%!!! Besides, Apple makes the best phones in the world. It's so worth the money.  I would pay 500% of the retail price just for that picture", friend: steve, minutesAgo: 42, context: context)
        FriendsController.createMessage(text: "Are you sure? I heard from my friends that Samsung makes better phones.", friend: steve, minutesAgo: 36, context: context, isSender: true)
        FriendsController.createMessage(text: "That's not true.  iPhones are the best. ", friend: steve, minutesAgo: 31, context: context)
        FriendsController.createMessage(text: "Wait, are you sure you are the real Steve Jobs? You sound fake.", friend: steve, minutesAgo: 21, context: context, isSender: true)
        FriendsController.createMessage(text: "How about 93.318512% off instead?", friend: steve, minutesAgo: 12, context: context)
        FriendsController.createMessage(text: "Really, you'd give me 93% off? I would love to buy the phone with your face engraved on it at that price", friend: steve, minutesAgo: 8, context: context, isSender: true)
    }
    
    private func createDonaldMessages(context: NSManagedObjectContext) {
        let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        donald.name = "Donald Trump"
        donald.profileImageName = "donald_trump_profile"
        
        FriendsController.createMessage(text: "Hello, I am the the current president of the United States", friend: donald, minutesAgo: 56, context: context)
        FriendsController.createMessage(text: "Shouldn't you be running the country right now?  Why are you messaging me?", friend: donald, minutesAgo: 51, context: context, isSender: true)
        FriendsController.createMessage(text: "Join me. I'm going to make America great again. You can be part of this from right at your home: 21 ABC St., Realtown, Alaska", friend: donald, minutesAgo: 45, context: context)
        FriendsController.createMessage(text: "Uhh, no thanks.  I think I'm just going to eat my mac and cheese.  You go ahead and enjoy making America great again.", friend: donald, minutesAgo: 42, context: context, isSender: true)
        FriendsController.createMessage(text: "Wait a minute... how did you know my home address?", friend: donald, minutesAgo: 39, context: context, isSender: true)
    }
    
    private func createGandhiMessages(context: NSManagedObjectContext) {
        let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        gandhi.name = "Mahatma Gandhi"
        gandhi.profileImageName = "gandhi"
        
        FriendsController.createMessage(text: "Hello, my name is Gandhi", friend: gandhi, minutesAgo: 60 * 24 * 8, context: context)
        FriendsController.createMessage(text: "Live as if you were to die tomorrow. Learn as if you were to live forever", friend: gandhi, minutesAgo: 60 * 24 * 4, context: context)
        FriendsController.createMessage(text: "Okay... thanks...", friend: gandhi, minutesAgo: 60 * 24 * 2, context: context, isSender: true)
        FriendsController.createMessage(text: "In a gentle way, you can shake the world.", friend: gandhi, minutesAgo: 60 * 24, context: context)
    }
    
    private func createHillaryMessages(context: NSManagedObjectContext) {
        let hillary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        hillary.name = "Hillary Clinton"
        hillary.profileImageName = "hillary_profile"
        
        FriendsController.createMessage(text: "Good afternoon...", friend: hillary, minutesAgo: 60 * 24 * 22, context: context)
    }
    
    static func createMessage(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = NSNumber(value: isSender)
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

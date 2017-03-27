//
//  FriendsController.swift
//  FacebookMessengerClone
//
//  Created by Joseph Kim on 3/24/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit
import CoreData

class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {

    private let cellId = "cellId"
    private let cellHeight: CGFloat = 100
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = { [weak self] in
        guard let this = self else { return NSFetchedResultsController<NSFetchRequestResult>() }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessage.date", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "lastMessage != nil")
        let context = (UIApplication.shared.delegate as! AppDelegate).getContext()
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = this
        return frc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
    
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)

        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print("\(err)")
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset chat data", style: .plain, target: self, action: #selector(resetData))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            if count == 0 { setupData() }
        }
    }
    
    func resetData() {
        setupData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        collectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            return count
        }
        
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        
        let friend = fetchedResultsController.object(at: indexPath) as! Friend
        
        cell.message = friend.lastMessage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: cellHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = ChatLogController(collectionViewLayout: layout)
        
        let friend = fetchedResultsController.object(at: indexPath) as! Friend

        controller.friend = friend
        navigationController?.pushViewController(controller, animated: true)
    }
}

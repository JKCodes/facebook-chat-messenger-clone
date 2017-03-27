//
//  ChatLogController.swift
//  FacebookMessengerClone
//
//  Created by Joseph Kim on 3/25/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit
import CoreData

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    private let cellId = "cellId"
    private let defaultCellHeight: CGFloat = 100
    private let cellWidth: CGFloat = 250
    private let contentOffset: CGFloat = 16
    private let cellPadding: CGFloat = 8
    private let cellRightMargin: CGFloat = 16
    private let messageInputContainerHeight: CGFloat = 48
    private let sendButtonWidth: CGFloat = 60
    private let topBorderViewHeight: CGFloat = 0.5
    
    private var messageInputBottomConstraint: NSLayoutConstraint?
    
    var blockOperations = [BlockOperation]()
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = { [weak self] in
        guard let this = self, let friendName = this.friend?.name else { return NSFetchedResultsController<NSFetchRequestResult>() }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friendName)
        let context = (UIApplication.shared.delegate as! AppDelegate).getContext()
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = this
        return frc
    }()
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            
           
        }
    }
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    lazy var sendButton: UIButton = { [weak self] in
        guard let this = self else { return UIButton() }
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor.rgb(r: 0, g: 137, b: 249), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(this, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    let topBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print("\(err)")
        }
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(simulate))
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(messageInputContainerView)
        
        messageInputBottomConstraint = messageInputContainerView.anchorAndReturn(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: messageInputContainerHeight)[1]

        
        setupInputComponents()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    func simulate() {
        guard let friend = friend else { return }

        let context = (UIApplication.shared.delegate as! AppDelegate).getContext()
        FriendsController.createMessage(text: "An automated message from one minute ago", friend: friend, minutesAgo: 1, context: context)
        FriendsController.createMessage(text: "An automated message from just now", friend: friend, minutesAgo: 0, context: context)
        
        do {
            try context.save()
          
            
            
        } catch let err {
            print("\(err)")
        }
    }
    
    func handleSend() {
        guard let text = inputTextField.text, let friend = friend else { return }
        
        if text == "" { return }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).getContext()
        
        FriendsController.createMessage(text: text, friend: friend, minutesAgo: 0, context: context, isSender: true)
        
        do {
            try context.save()
            
            inputTextField.text = nil
        } catch let err {
            print("\(err)")
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let newIndexPath = newIndexPath else { return }
        
        if type == .insert {
            blockOperations.append(BlockOperation(block: { [weak self] in
                self?.collectionView?.insertItems(at: [newIndexPath])
            }))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({ [weak self] in
            guard let this = self else { return }
            for operation in this.blockOperations {
                operation.start()
            }
        }, completion: { [weak self] (completed) in
            guard let this = self, let count = this.fetchedResultsController.sections?[0].numberOfObjects else { return }
            let indexPath = IndexPath(item: count - 1, section: 0)
            self?.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        })
    }
    
    func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            
            if let newHeight = keyboardFrame?.height {
                messageInputBottomConstraint?.constant = isKeyboardShowing ? -newHeight : 0
            }
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                guard let this = self else { return }
                
                this.view.layoutIfNeeded()
                
            }, completion: { [weak self] (completed) in
                if isKeyboardShowing {
                    guard let this = self, let count = this.fetchedResultsController.sections?[0].numberOfObjects else { return }
                    let indexPath = IndexPath(item: count - 1, section: 0)
                    self?.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
                
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
        
        
    }
    
    private func setupInputComponents() {
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)

        topBorderView.anchor(top: messageInputContainerView.topAnchor, left: messageInputContainerView.leftAnchor, bottom: nil, right: messageInputContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: topBorderViewHeight)
        inputTextField.anchor(top: topBorderView.bottomAnchor, left: topBorderView.leftAnchor, bottom: messageInputContainerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: cellPadding, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        sendButton.anchor(top: inputTextField.topAnchor, left: inputTextField.rightAnchor, bottom: inputTextField.bottomAnchor, right: messageInputContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: sendButtonWidth, heightConstant: 0)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            return count
        }
        
        return 0
    }
    
    private func fittingRect(for text: String) -> CGRect {
        let size = CGSize(width: cellWidth, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        
        return estimatedFrame
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        let message = fetchedResultsController.object(at: indexPath) as! Message
        
        cell.messageTextView.text = message.text
        
        if let messageText = message.text, let profileImageName = message.friend?.profileImageName, let isSender = message.isSender {
            let estimatedFrame = fittingRect(for: messageText)
            cell.profileImageView.image = UIImage(named: profileImageName)
            
            if !isSender.boolValue {
                cell.messageTextView.frame = CGRect(x: ChatLogMessageCell.cellOffset + cellPadding, y: 0, width: estimatedFrame.width + contentOffset, height: estimatedFrame.height + contentOffset)
                cell.textBubbleView.frame = CGRect(x: ChatLogMessageCell.cellOffset - cellPadding, y: 0, width: estimatedFrame.width + contentOffset + cellPadding * 3, height: estimatedFrame.height + contentOffset)
                cell.profileImageView.isHidden = false
                cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = .black
            } else {
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width  - contentOffset - cellRightMargin - cellPadding, y: 0, width: estimatedFrame.width + contentOffset, height: estimatedFrame.height + contentOffset)
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - contentOffset - cellPadding * 2 - cellRightMargin, y: 0, width: estimatedFrame.width + contentOffset + cellPadding * 2, height: estimatedFrame.height + contentOffset)
                cell.profileImageView.isHidden = true
                cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
                cell.bubbleImageView.tintColor = UIColor.rgb(r: 0, g: 137, b: 249)
                cell.messageTextView.textColor = .white
            }
        }
 
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = fetchedResultsController.object(at: indexPath) as! Message
        
        if let messageText = message.text {
            let estimatedFrame = fittingRect(for: messageText)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + contentOffset)
        }
        
        return CGSize(width: view.frame.width, height: defaultCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
}

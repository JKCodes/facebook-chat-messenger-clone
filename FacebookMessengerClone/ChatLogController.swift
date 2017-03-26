//
//  ChatLogController.swift
//  FacebookMessengerClone
//
//  Created by Joseph Kim on 3/25/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    private let defaultCellHeight: CGFloat = 100
    private let cellWidth: CGFloat = 250
    private let contentOffset: CGFloat = 16
    private let cellPadding: CGFloat = 8
    private let cellRightMargin: CGFloat = 16
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            
            messages = friend?.messages?.allObjects as? [Message]
            
            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending })
        }
    }
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
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
        cell.messageTextView.text = messages?[indexPath.item].text
        
        if let message = messages?[indexPath.item], let messageText = message.text, let profileImageName = message.friend?.profileImageName, let isSender = message.isSender {
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
        
        if let messageText = messages?[indexPath.item].text {
            let estimatedFrame = fittingRect(for: messageText)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + contentOffset)
        }
        
        return CGSize(width: view.frame.width, height: defaultCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
}

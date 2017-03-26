//
//  ChatLogMessageCell.swift
//  FacebookMessengerClone
//
//  Created by Joseph Kim on 3/25/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit

class ChatLogMessageCell: BaseCell {
    
    private let profileImageLength: CGFloat = 30
    private let profileImageOffset: CGFloat = 8
    internal static let cellOffset: CGFloat = 30 + 8 * 2
    static let grayBubbleImage = #imageLiteral(resourceName: "bubble_gray").resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = #imageLiteral(resourceName: "bubble_blue").resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)

    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Example"
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatLogMessageCell.grayBubbleImage
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        // no anchors set for textBubbleView and messageTextView... size and location dynamically set for all views
        addSubview(textBubbleView)
        addSubview(messageTextView)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: profileImageOffset, bottomConstant: 0, rightConstant: 0, widthConstant: profileImageLength, heightConstant: profileImageLength)
        profileImageView.layer.cornerRadius = profileImageLength / 2
        
        textBubbleView.addSubview(bubbleImageView)
        bubbleImageView.fillSuperview()
    }
}

//
//  ChatLogMessageCell.swift
//  FacebookMessengerClone
//
//  Created by Joseph Kim on 3/25/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit

class ChatLogMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Example"
        textView.isEditable = false
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(messageTextView)
        messageTextView.fillSuperview()
    }
}

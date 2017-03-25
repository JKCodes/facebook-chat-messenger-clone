//
//  MessageCell.swift
//  FacebookMessengerClone
//
//  Created by Joseph Kim on 3/24/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit

class MessageCell: BaseCell {

    private static let profileImageCornerRadius: CGFloat = 34
    private static let hasReadImageCornerRadius: CGFloat = 10
    private let profileImageLength: CGFloat = 68
    private let hasReadImageLength: CGFloat = 20
    private let containerViewHeight: CGFloat = 50
    private let contentOffset: CGFloat = 12
    private let dividerLineOffset: CGFloat = 82
    private let dividerLineHeight: CGFloat = 1
    private let messageLabelHeight: CGFloat = 24
    private let timeLabelWidth: CGFloat = 80
    private let timeLabelHeight: CGFloat = 24
    
    var message: Message? {
        didSet{
            nameLabel.text = message?.friend?.name
            
            if let profileImageName = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
                hasReadImageView.image = UIImage(named: profileImageName)
            }
            
            messageLabel.text = message?.text
            
            if let date = message?.date {

                let dateFormatter = DateFormatter()
                let elapsedTimeInSeconds = Date().timeIntervalSince(date as Date)
                let secondsInDays: TimeInterval = 60 * 60 * 24
                
                if elapsedTimeInSeconds > 7 * secondsInDays {
                    dateFormatter.dateFormat = "MM/dd/yy"
                } else if elapsedTimeInSeconds > secondsInDays {
                    dateFormatter.dateFormat = "EEE"
                } else {
                    dateFormatter.dateFormat = "h:mm a"
                }
                
                timeLabel.text = dateFormatter.string(from: date as Date)
            }
            
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.rgb(r: 0, g: 134, b: 249) : .white
            nameLabel.textColor = isHighlighted ? .white : .black
            timeLabel.textColor = isHighlighted ? .white : .black
            messageLabel.textColor = isHighlighted ? .white : .black
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = MessageCell.profileImageCornerRadius
        imageView.layer.masksToBounds = true
        imageView.image = #imageLiteral(resourceName: "zuckprofile")
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "TEMPORARY NAME"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "some message will go here in very very near futere.  Just a temporary text for now"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "99:99 PM"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = MessageCell.hasReadImageCornerRadius
        imageView.layer.masksToBounds = true
        imageView.image = #imageLiteral(resourceName: "zuckprofile")
        return imageView
    }()
    
    override func setupViews() {
        addSubview(dividerLineView)
        
        setupProfileImageView()
        setupContainerView()
        
       
        dividerLineView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: dividerLineOffset, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: dividerLineHeight)
    }
    
    private func setupProfileImageView() {
        addSubview(profileImageView)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: contentOffset, bottomConstant: 0, rightConstant: 0, widthConstant: profileImageLength, heightConstant: profileImageLength)
        profileImageView.anchorCenterYToSuperview()
    }
    
    private func setupContainerView() {
        addSubview(containerView)
        
        containerView.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: contentOffset, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: containerViewHeight)
        containerView.anchorCenterYToSuperview()
    
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        
        nameLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: timeLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        messageLabel.anchor(top: nameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: messageLabelHeight)
        timeLabel.anchor(top: containerView.topAnchor, left: nameLabel.rightAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: contentOffset, widthConstant: timeLabelWidth, heightConstant: timeLabelHeight)
        hasReadImageView.anchor(top: nil, left: messageLabel.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: contentOffset / 1.5, bottomConstant: 0, rightConstant: contentOffset, widthConstant: hasReadImageLength, heightConstant: hasReadImageLength)
    }
    
}

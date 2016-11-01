//
//  TweetCell.swift
//  twitter
//
//  Created by emersonmalca on 11/1/16.
//  Copyright © 2016 Emerson Malca. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UICollectionViewCell {
    
    @IBOutlet weak var retweetedLabelStackView: UIStackView!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func update(withTweet tweet:Tweet) {
        
        nameLabel.text = tweet.owner.name
        handleLabel.text = "@\(tweet.owner.handle)"
        avatar.setImageWith(tweet.owner.avatarURL)
        bodyLabel.text = tweet.text
    }
}


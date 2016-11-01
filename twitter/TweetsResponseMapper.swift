//
//  TweetsResponseMapper.swift
//  twitter
//
//  Created by emersonmalca on 10/31/16.
//  Copyright © 2016 Emerson Malca. All rights reserved.
//

import UIKit

class TweetsResponseMapper: NSObject {
    
    lazy var formatter = { () -> DateFormatter in 
        let form = DateFormatter()
        form.dateFormat = "EEE MMM d HH:mm:ss Z y"
        return form
    }()

    func toTweets(_ dicts:[Dictionary<String, Any>]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        for dict in dicts {
            let text = dict["text"] as? String
            let retweetCount = dict["retweet_count"] as? Int ?? 0
            let favoritesCount = dict["favourites_count"] as? Int ?? 0
            let timeString = dict["created_at"] as? String
            let timestamp = formatter.date(from: timeString!)
            
            let tweet = Tweet(text: text, timestamp: timestamp, retweetCount: retweetCount, favoritesCount: favoritesCount)
            tweets.append(tweet)
            
        }
        
        return tweets
    }
}

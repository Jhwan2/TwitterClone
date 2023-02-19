//
//  Tweet.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/12.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetID: String
    var likes: Int
    let retweetCount: Int
    var timestamp: Date!
    let uid: String
    var user: User
    var didLike = false
    
    init(user: User,tweetID: String, dic: [String:Any]) {
        self.tweetID = tweetID
        self.user = user
        self.caption = dic["caption"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.retweetCount = dic["retweetCount"] as? Int ?? 0
        self.likes = dic["likes"] as? Int ?? 0
        
        if let timestamp = dic["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }

    
}

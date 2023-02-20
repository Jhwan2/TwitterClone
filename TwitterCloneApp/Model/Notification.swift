//
//  Notification.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/02/20.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    var tweetID: String?
    var timestamp: Date!
    var user: User
    var tweet: Tweet?
    var type: NotificationType!
    
    init(user: User, dic: [String: AnyObject]) {
        self.user = user
        
        if let tweetID = dic["tweetID"] as? String {
            self.tweetID = tweetID
        }
        
        if let timestamp = dic["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        if let type = dic["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
    
}

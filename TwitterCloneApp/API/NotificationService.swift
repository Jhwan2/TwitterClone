//
//  NotificationService.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/02/20.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType, tweet: Tweet? = nil, user: User? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID
            REF_NOTIFICATION.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        } else if let user = user {
            REF_NOTIFICATION.child(user.uid).childByAutoId().updateChildValues(values)
        }
    }
    
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        var notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_NOTIFICATION.child(uid).observe(.childAdded) { snapshot in
            guard let dic = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dic["uid"] as? String else { return }
            
            UserService.shard.fetchUser(uid: uid) { user in
                let notification = Notification(user: user, dic: dic)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
}

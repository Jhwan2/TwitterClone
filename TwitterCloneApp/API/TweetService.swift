//
//  TweetService.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/12.
//

import Firebase

struct TweetService {
    static let shard = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let value = ["uid": uid,
                     "timestamp":Int(NSDate().timeIntervalSince1970),
                     "likes": 0,
                     "retweets": 0,
                     "caption": caption] as [String: Any]
        REF_TWEETS.childByAutoId().updateChildValues(value, withCompletionBlock: completion)
        
    }
    
    
    func fetchTweets(completion: @escaping([Tweet])-> Void) {
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dic = snapshot.value as? [String:Any] else { return }
            let tweetID = snapshot.key
            let tweet = Tweet(tweetID: tweetID, dic: dic)
            tweets.append(tweet)
            completion(tweets)
        }
    }
}

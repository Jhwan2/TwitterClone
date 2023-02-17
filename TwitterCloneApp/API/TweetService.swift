//
//  TweetService.swift
//  TwitterCloneApp
//
//  Created by 이주환 on 2023/01/12.
//

import Firebase

struct TweetService {
    static let shard = TweetService()
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let value = ["uid": uid,
                     "timestamp":Int(NSDate().timeIntervalSince1970),
                     "likes": 0,
                     "retweets": 0,
                     "caption": caption] as [String: Any]
        switch type {
        case .tweet:
            REF_TWEETS.childByAutoId().updateChildValues(value) { Error, ref in
                guard let tweetID = ref.key else { return }
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(value, withCompletionBlock: completion)
        }
    }
    
    
    func fetchTweets(completion: @escaping([Tweet])-> Void) {
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dic = snapshot.value as? [String:Any] else { return }
            guard let uid = dic["uid"] as? String else { return }
            
            let tweetID = snapshot.key
            UserService.shard.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user,tweetID: tweetID, dic: dic)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dic = snapshot.value as? [String:Any] else { return }
                guard let uid = dic["uid"] as? String else { return }
                
                UserService.shard.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user,tweetID: tweetID, dic: dic)
                    tweets.append(tweet)
                    completion(tweets)
                }
                
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dic =  snapshot.value as? [String: AnyObject] else { return }
            let tweetID = snapshot.key
            
            guard let uid = dic["uid"] as? String else { return }
            
            UserService.shard.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user,tweetID: tweetID, dic: dic)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
}
